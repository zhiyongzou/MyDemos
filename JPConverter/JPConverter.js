//
//
//  JPConverter.js
//
//  Created by zzyong on 2020/03/20.
//  Copyright © 2020 zzyong. All rights reserved.
//

function didConverterButtonClick() 
{
  JPAspectDefineClass = [];
  JPConditionIndex = 0;

  var objcCodeTextView = document.getElementById('jp_objc_code_textview');
  var jsonCodeTextView = document.getElementById("jp_json_code_textview");

  jsonCodeTextView.value = converterCodeToJson(objcCodeTextView.value);
}

function converterCodeToJson(codeString)
{
  let impList = codeString.split(JPClassEndTag);

  if (impList.length == 0) {
    return "";
  }

  let Aspects = [];

  for (let impIdx = impList.length - 1; impIdx >= 0; impIdx--) {

    var impString = impList[impIdx].trim();
    if (impString.length == 0) {
      continue;
    }

    // 移除 JPClassBeginTag 之前的所有字符
    impString = impString.substring(impString.indexOf(JPClassBeginTag));

    let enterChar = "\n";
    let firstEnterIdx = impString.indexOf(enterChar);

    // 获取类名
    let classString = impString.substring(0, firstEnterIdx);
    let className = classString.replace(JPClassBeginTag, "").trim();
    if (className.length == 0) {
      // 没有类名
      return;
    }

    // 类的所有方法内容
    let methodContent = impString.substring(firstEnterIdx + enterChar.length);
    // 方法开头匹配正则
    let regularExp = /[-,\+]+\s*\(\s*[a-zA-Z]+\s*\**\s*\)\s*/igm;
    let methodBeginList = methodContent.match(regularExp);

    if (methodBeginList == null) {
      // 该类没有方法
      continue;
    } else {
      
      var returnType = 0;
      var curMethodContent = methodContent;
      for (let idx = (methodBeginList.length - 1); idx >= 0; idx--) {
        let methodBeginStr = methodBeginList[idx];
        let isClassMethod = (methodBeginStr.indexOf("-") == -1);
        returnType = JPArgumentType(getBracketsValue(methodBeginStr));

        if (idx == 0) {
          addClassAcpset(className, isClassMethod, returnType, curMethodContent.replace(methodBeginStr, ""), Aspects);
        } else {

          let methodIdx =  curMethodContent.lastIndexOf(methodBeginStr);
          let methodString = curMethodContent.substring(methodIdx);
          addClassAcpset(className, isClassMethod, returnType, methodString.replace(methodBeginStr, ""), Aspects);
        
          curMethodContent = curMethodContent.substring(0, methodIdx);
        }
      }
    }
  }

  let JPAspect = { };
  if (JPAspectDefineClass.length > 0) {
    JPAspect["AspectDefineClass"] = JPAspectDefineClass;
  }
  JPAspect["Aspects"] = Aspects;

  return JSON.stringify(JPAspect, null, 4);
}

function addClassAcpset(className, isClassMethod, returnType, methodString, Aspects)
{
  methodString = methodString.replace(/\n/igm, "").trim();

  if (methodString.length == 0) {
    return;
  }

  // JS解析使用到的所有局部变量
  var JSParseLocalInstanceList = {};
  var classAcpset = JPClassAspect(className, isClassMethod);
  // { 位置
  let firstOpenBraceIdx = methodString.indexOf("{");

  // 方法名
  var selName = "";
  let methodNameString = methodString.substring(0, firstOpenBraceIdx);

  // 获取方法参数类型
  let typeRegExp = /\s*\(\s*[a-zA-Z]+\s*\**\s*\)\s*/igm;
  methodArgumentTypeList = methodNameString.match(typeRegExp);
  if (methodArgumentTypeList != null) {
    for (let index = 0; index < methodArgumentTypeList.length; index++) {
      const element = methodArgumentTypeList[index];
      methodNameString = methodNameString.replace(element, "");
    }
  }

  // 移除 : 前面的空格
  let colonregExp = /\s*:\s*/igm;
  methodNameString = methodNameString.replace(colonregExp, ":");

  if (methodNameString.indexOf(":") != -1) {

    let methodNameSplits = methodNameString.split(" ");
    var selArgumentNames = [];
    for (let idx = 0; idx < methodNameSplits.length; idx++) {
      let element = methodNameSplits[idx];
      if (element.length == 0) {
          continue;
      }
      let colonIdx = element.indexOf(":");
      selName = selName + element.substring(0, colonIdx) + ":";
      let argumentName = element.substring(colonIdx + 1).trim();
      if (argumentName.length > 0) {
        selArgumentNames.push(argumentName);
      }
    }
    if (selArgumentNames.length > 0) {
      classAcpset["argumentNames"] = selArgumentNames;

      if (methodArgumentTypeList != null) {
        for (let index = 0; index < methodArgumentTypeList.length; index++) {
          const element = methodArgumentTypeList[index];
          let selArgumentName = selArgumentNames[index];
          JSParseLocalInstanceList[selArgumentName] = JSParseInstance(JPArgumentType(getBracketsValue(element)), selArgumentName);
        }
      }
    }

  } else {
      // 无参数
      selName = methodNameString.trim();
  }

  classAcpset.selName = selName;

  // 移除{}的方法实现
  let methodImpString = methodString.substring(firstOpenBraceIdx + 1, methodString.length - 1);
  let aspectCustomMessages = getCustomMessages(JSParseLocalInstanceList, returnType, methodImpString);
  if (aspectCustomMessages.length > 0) {
    classAcpset["customMessages"] = aspectCustomMessages;
  }

  let hookType = document.getElementById('jpHookType').value;
  if (hookType == "JPAspectHookCustomInvokeInstead") {
    classAcpset["hookType"] = 3;
  } else if (hookType == "JPAspectHookCustomInvokeAfter") {
    classAcpset["hookType"] = 2;
  } else {
    classAcpset["hookType"] = 1;
  }
  
  Aspects.unshift(classAcpset);
}

function getCustomMessages(JSParseLocalInstanceList, returnType, methodImpString)
{
  var aspectMessages = [];
  let ifStatementMap = {};

  do {
    if (methodImpString == null) {
      break;
    }

    // if 语句
    let ifbegins = methodImpString.match(/if\s*\(/igm);
    if (ifbegins != null) {
      var ifAltIdx = 0;
      var curIfContent = methodImpString;
      let ifRegularExp = /if\s*\(.*\)\s*\{.*\}/igm;
      for (let idx = (ifbegins.length - 1); idx >= 0; idx--) {
        const ifBegin = ifbegins[idx];

        var ifStatements = null;
        if (idx == 0) {
          ifStatements = curIfContent.match(ifRegularExp);
        } else {

          let ifIdx =  curIfContent.lastIndexOf(ifBegin);
          let ifString = curIfContent.substring(ifIdx);
          ifStatements = ifString.match(ifRegularExp);
          curIfContent = curIfContent.substring(0, ifIdx);
        }

        if (ifStatements != null) {
          for (let index = 0; index < ifStatements.length; index++) {
            const element = ifStatements[index];
            let ifAlt = "jp_if_" + String(ifAltIdx);
            methodImpString = methodImpString.replace(element, ifAlt + ";");
            ifStatementMap[ifAlt] = element;
          }
          ifAltIdx ++;
        }
      }
    }

    let methodStatements = methodImpString.split(";");
    if (methodStatements == null) {
      break;
    }

    for (let index = 0; index < methodStatements.length; index++) {
      const element = methodStatements[index];

      let ifStatement = ifStatementMap[element.trim()];
      // 移除语句所有多余的空格符
      let statement = JPRemoveObjectiveCStatementUnuseWhiteSpace(ifStatement != null ? ifStatement : element);
      if (ifStatement != null) {
        parseIfStatement(aspectMessages, JSParseLocalInstanceList, returnType, statement);
      } else {
        let aspectMessage = getAspectMessage(JSParseLocalInstanceList, returnType, statement);
        if (aspectMessage != null) {
          aspectMessages.push(aspectMessage);
        }
      }
    }
  } while (0);

  return aspectMessages;
}

// 解析 if 语句
function parseIfStatement(aspectMessages, JSParseLocalInstanceList, returnType, statement)
{
  // { 位置
  let firstOpenBraceIdx = statement.indexOf("{");
  let ifImpString = statement.substring(firstOpenBraceIdx + 1, statement.length - 1);
  if (ifImpString.length == 0) {
    return;
  }

  var ifCondition = statement.substring(statement.indexOf("(") + 1, statement.indexOf(")")).trim();
  var conditionKey = null;
  
  ifCondition = JPFormatCondition(JSParseLocalInstanceList, ifCondition);
  if (JPOperator(ifCondition) != null) {
    conditionKey = "conditionKey_" + String(JPConditionIndex);
    aspectMessages.push(JPInvokeCondition(conditionKey, ifCondition));
    JPConditionIndex ++;
  } else {
    JPAlert(ifCondition + ": 必须指定运算符");
    return;
  }

  let methodStatements = ifImpString.split(";");
  if (methodStatements == null) {
    return;
  }

  for (let index = 0; index < methodStatements.length; index++) {
    const element = methodStatements[index];

    // 移除语句所有多余的空格符
    let statement = JPRemoveObjectiveCStatementUnuseWhiteSpace(element);
    let aspectMessage = getAspectMessage(JSParseLocalInstanceList, returnType, statement);
    if (aspectMessage != null) {
      aspectMessage["invokeCondition"] = {
        "conditionKey": conditionKey
      }
      aspectMessages.push(aspectMessage);
    }
  }
}

function getAspectMessage(JSParseLocalInstanceList, returnType, statement)
{
  if (statement == null) {
    return null;
  }

  if (statement.length == 0) {
    return null;
  }

  let aspectMessage = null;

  if (statement.indexOf("=") != -1) {
    // 赋值语句或点语法 
    aspectMessage = parseAssignStatement(JSParseLocalInstanceList, statement);

  } else if (statement.indexOf("[") != -1) { 
    // OC 方法调用
    aspectMessage = parseObjectiveCMethod(JSParseLocalInstanceList, null, statement);

  } else {

    let returnIdx = statement.indexOf(JPReturnKey);
    if (returnIdx != -1) {
      // return 语句
      aspectMessage = parseReturnStatement(JSParseLocalInstanceList, returnType, statement);
    } else {
      JPAlert("不支持该语句类型: " + statement);
    }
  }

  return aspectMessage;
}
