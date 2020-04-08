//
//
//  JPConverter.js
//
//  Created by zzyong on 2020/03/20.
//  Copyright © 2020 zzyong. All rights reserved.
//

let JPClassBeginTag = "@implementation";
let JPClassEndTag = "@end";
let JPReturnKey = "return";

function keydownHandler(textView)
{
    // Tab key
    if (event.keyCode == 9) {
      var content = textView.value;
      var focusIndex = textViewCursortPosition(textView);
      textView.value = insertString(content, focusIndex, "    ");
      setTextViewFocusPosition(textView, (focusIndex + 4));
      event.returnValue = false;
    }
}

// 设置光标位置
function setTextViewFocusPosition(textView, pos)
{
  if(textView.setSelectionRange) {
      // IE Support
      textView.focus();
      textView.setSelectionRange(pos, pos);
  }else if (textView.createTextRange) {
      // Firefox support
      var range = textView.createTextRange();
      range.collapse(true);
      range.moveEnd('character', pos);
      range.moveStart('character', pos);
      range.select();
  }
}

// 获取光标位置
function textViewCursortPosition(textView) 
{
  var cursorIndex = 0;
  if (document.selection) {
      // IE Support
      textView.focus();
      var range = document.selection.createRange();
      range.moveStart('character', -textView.value.length);
      cursorIndex = range.text.length;
  } else if (textView.selectionStart || textView.selectionStart==0) {
      // another support
      cursorIndex = textView.selectionStart;
  }
  return cursorIndex;
}

function didConverterButtonClick() 
{
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

  let JPAspect = {
    "AspectDefineClass": [],
    "Aspects": [] 
  };

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
          addClassAcpset(className, isClassMethod, returnType, curMethodContent.replace(methodBeginStr, ""), JPAspect.Aspects);
        } else {

          let methodIdx =  curMethodContent.lastIndexOf(methodBeginStr);
          let methodString = curMethodContent.substring(methodIdx);
          addClassAcpset(className, isClassMethod, returnType, methodString.replace(methodBeginStr, ""), JPAspect.Aspects);
        
          curMethodContent = curMethodContent.substring(0, methodIdx);
        }
      }
    }
  }

  return JSON.stringify(JPAspect, null, 4);
}

function addClassAcpset(className, isClassMethod, returnType, methodString, Aspects)
{
  methodString = methodString.trim().replace("\n", "");

  if (methodString.length == 0) {
    return;
  }

  var classAcpset = {
    className: className,
    selName: "",
    isClassMethod: isClassMethod,
    hookType: 1,
    //argumentNames: [],
    //customMessages: []
  };
  // { 位置
  let firstOpenBraceIdx = methodString.indexOf("{");

  // 方法名
  var selName = "";
  let methodNameString = methodString.substring(0, firstOpenBraceIdx);

  // 讲方法参数替换为空字符，例如：(BOOL) ---> ""
  let typeRegExp = /\s*\(\s*[a-zA-Z]+\s*\**\s*\)\s*/igm;
  methodNameString = methodNameString.replace(typeRegExp, "");

  // 移除 : 前面的空格
  let colonregExp = /\s*:/igm;
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
    }

  } else {
      // 无参数
      selName = methodNameString.trim();
  }

  classAcpset.selName = selName;

  // 移除{}的方法实现
  let methodImpString = methodString.substring(firstOpenBraceIdx + 1, methodString.length - 1);
  let aspectCustomMessages = getCustomMessages(returnType, methodImpString);
  if (aspectCustomMessages.length > 0) {
    classAcpset["customMessages"] = aspectCustomMessages;
  }

  Aspects.unshift(classAcpset);
}

function getCustomMessages(returnType, methodImpString)
{
  var aspectMessages = [];

  do {
    if (methodImpString == null) {
      break;
    }

    let methodStatements = methodImpString.split(";");
    if (methodStatements == null) {
      break;
    }

    for (let index = 0; index < methodStatements.length; index++) {
      const element = methodStatements[index];
      let aspectMessage = getAspectMessage(returnType, element);
      if (aspectMessage != null) {
        aspectMessages.push(aspectMessage);
      }
    }
  } while (0);

  return aspectMessages;
}

function getAspectMessage(returnType, statement)
{
  if (statement == null) {
    return null;
  }

  statement = statement.trim().replace("\n", "");
  if (statement.length == 0) {
    return null;
  }

  var aspectMessage = {
    message: "",
    //invokeCondition: {},
    messageType: 0,
    //arguments: {},
    //localInstanceKey: "",
  };

  let returnIdx = statement.indexOf(JPReturnKey);
  if (returnIdx != -1) {
    aspectMessage.messageType = 1;
    if (statement == JPReturnKey) {
      aspectMessage.message = JPReturnKey;
    } else {
      let returnValue = statement.replace(JPReturnKey, "").trim();
      if (returnValue == "YES") {
        aspectMessage.message = JPReturnKey + "=" + String(returnType) + ":1";
      } else if(returnValue == "NO") {
        aspectMessage.message = JPReturnKey + "="  + String(returnType) + ":0";
      } else {
        aspectMessage.message = JPReturnKey + "="  + String(returnType) + ":0";
      }
    }
  }

  return aspectMessage;
}

function getBracketsValue(string)
{
  if (string == null) {
    return "";
  }

  let leftBracketIdx = string.indexOf("(");
  if (leftBracketIdx == -1) {
    return string;
  }

  return string.substring(leftBracketIdx + 1).replace(")", "");
}

/**
 * 返回函数返回类型
 * @param typeString  返回类型，格式：BOOL
 */
function JPArgumentType(typeString)
{
  // JPArgumentTypeUnknown
  var argumentType = 0;

  do {
    if (typeString == null) {
      break;
    }

    if (typeString == "void") {
      break;
    }

    typeString = typeString.trim();
    if (typeString == "id" || typeString == "instancetype" || typeString.indexOf("*") != -1) {
      argumentType = 1;
    } else if (typeString == "Class") {
      argumentType = 2;
    } else if (typeString == "BOOL" || typeString == "bool") {
      argumentType = 3;
    } else if (typeString == "NSInteger" || typeString == "long") {
      argumentType = 4;
    } else if (typeString == "NSUInteger" || typeString == "unsigned long") {
      argumentType = 5;
    } else if (typeString == "short") {
      argumentType = 6;
    } else if (typeString == "unsigned short") {
      argumentType = 7;
    } else if (typeString == "long long") {
      argumentType = 8;
    } else if (typeString == "unsigned long long") {
      argumentType = 9;
    } else if (typeString == "float") {
      argumentType = 10;
    } else if (typeString == "double" || typeString == "CGFolat") {
      argumentType = 11;
    } else if (typeString == "int") {
      argumentType = 12;
    } else if (typeString == "unsigned int") {
      argumentType = 13;
    } else if (typeString == "SEL") {
      argumentType = 14;
    } else if (typeString == "CGSize") {
      argumentType = 15;
    } else if (typeString == "CGPoint") {
      argumentType = 16;
    } else if (typeString == "CGRect") {
      argumentType = 17;
    } else if (typeString == "UIEdgeInsets") {
      argumentType = 18;
    } else if (typeString == "NSRange") {
      argumentType = 19;
    }     

  } while (0);

  return argumentType;
}
