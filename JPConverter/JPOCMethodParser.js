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

  statement = statement.trim().replace(/\\n/igm, "");
  if (statement.length == 0) {
    return null;
  }

  var aspectMessage = {
    message: "",
    messageType: 0,
  };

  if (localInstanceKey != null && localInstanceKey.length > 0) {
    aspectMessage["localInstanceKey"] = localInstanceKey;
  }

  // 移除 [
  statement = statement.replace(/\[/igm, "");

  // 使用 ] 分割
  statementComponents = statement.split(JPRightSquareBracket);

  var JPMessage = "";
  for (let index = 0; index < statementComponents.length; index++) {
    var statementComponent = statementComponents[index].trim();

    if (statementComponent.length == 0) {
      continue;
    }

    if (index == 0) {
      let whiteSpaceIdx = statementComponent.indexOf(" ");
      let firstTarget = statementComponent.substring(0, whiteSpaceIdx);
      JPMessage = JPMessage + firstTarget;
      statementComponent = statementComponent.substring(whiteSpaceIdx).trim();
    }
    
    let selArgumentComponents = statementComponent.match(/:_*@*\(*"*[a-zA-Z0-9]*\)*"*\(*[0-9]*\.*\,*\)*\s+/igm);
    var selArguments = [];
    if (selArgumentComponents != null) {
      for (let index = 0; index < selArgumentComponents.length; index++) {
        const argument = selArgumentComponents[index];
        statementComponent = statementComponent.replace(argument, ":");

        if (argument.indexOf("nil") != -1 || argument.indexOf("NULL") != -1) {
          continue;
        }

        let argumentType = 0;
        let argumentValue = "";
        if (argument.indexOf("@") != -1) {
          if (argument.indexOf("(") != -1) {
            argumentValue = argument.replace("@", "").replace("(", "").replace(")", "").trim();
          } else {
            argumentValue = argument.replace("@", "").replace("\"", "").trim();
          }
          argumentType = 1;
        } else if (argument.indexOf("YES") != -1) {
          argumentType = 3;
          argumentValue = "1";
        } else if (argument.indexOf("NO") != -1) {
          argumentType = 3;
          argumentValue = "0";
        } else {
          argumentValue = argument.trim();
          let JPArgument = JPAllInstance[argumentValue];
          if (JPArgument != null) {
            argumentType = JPArgument["type"];
          }
        }
        selArguments.push[{"index": index, "value": argumentValue, "type": argumentType}];
      }
    }
    statementComponent = statementComponent.replace(/\s/igm, "");
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