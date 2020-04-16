//
//
//  JPOCMethodParser.js
//
//  Created by zzyong on 2020/03/20.
//  Copyright © 2020 zzyong. All rights reserved.
//

// 解析 OC 方法
function parseObjectiveCMethod(JPAllInstance, localInstanceKey, statement)
{
  if (statement == null) {
    return null;
  }

  if (statement.length == 0) {
    return null;
  }

  var aspectMessage = JPAspectMessage();

  if (localInstanceKey != null && localInstanceKey.length > 0) {
    aspectMessage["localInstanceKey"] = localInstanceKey;
  }

  // 移除 [
  statement = statement.replace(/\[/igm, "");

  // 使用 ] 分割
  statementComponents = statement.split(JPRightSquareBracket);

  var JPMessage = "";
  for (let index = 0; index < statementComponents.length; index++) {
    var statementComponent = statementComponents[index];

    if (statementComponent.length == 0) {
      continue;
    }

    if (index == 0) {
      let whiteSpaceIdx = statementComponent.indexOf(" ");
      let firstTarget = statementComponent.substring(0, whiteSpaceIdx);
      if (firstTarget != "self" && firstTarget != "super" && JPAllInstance[firstTarget] == null) {
        JPAspectDefineClass.push(firstTarget);
      }
      JPMessage = JPMessage + firstTarget;
      statementComponent = statementComponent.substring(whiteSpaceIdx).trim();
    }

    // 多加一个空格防止出现镜像参数替换错误问题。例如：colorWithRed:green:blue:alpha:alpha
    statementComponent = statementComponent + " ";
    var selArgumentComponents = statementComponent.match(/:[a-zA-Z0-9]+\s*/igm);
    var selArguments = [];
    if (selArgumentComponents != null) {
      for (let index = 0; index < selArgumentComponents.length; index++) {
        var argument = selArgumentComponents[index];
        statementComponent = statementComponent.replace(argument, ":");

        if (argument.indexOf("nil") != -1 || argument.indexOf("NULL") != -1) {
          continue;
        }

        // 移除 :
        argument = argument.substring(1).trim();

        let argumentType = 0;
        let argumentValue = "";
        
        if (argument == "self") {
          argumentType = 1;
          argumentValue = argument;
        } else {

          let JPTempArgumnt = JPAllInstance[argument];
          if (typeof JPTempArgumnt == "object") {

            argumentValue = JPTempArgumnt["value"];
            argumentType = JPTempArgumnt["type"];

          } else if (typeof JPTempArgumnt == "number") {

            argumentValue = argument;
            argumentType = JPTempArgumnt["type"];

          } else {
            JPAlert("[ " + statement + " ]" + JPTempArgumnt + "参数错误");
          }
        }
        selArguments.push({"index": index, "value": argumentValue, "type": argumentType});
      }
    }
    JPMessage = JPMessage + "." + statementComponent;
    
    if (selArguments.length > 0) {
      if (aspectMessage.arguments == null) {
        aspectMessage["arguments"] = {};
      }
      aspectMessage.arguments[JPMessage] = selArguments;
    }
  }
  aspectMessage.message = JPMessage;
  return aspectMessage;
}