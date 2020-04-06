//
//
//  JPConverter.js
//
//  Created by zzyong on 2020/03/20.
//  Copyright © 2020 zzyong. All rights reserved.
//

let JPClassBeginTag = "@implementation";
let JPClassEndTag = "@end";

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

// 指定位置插入字符串
function insertString(soure, toIndex, newStr)
{   
  return soure.slice(0, toIndex) + newStr + soure.slice(toIndex);
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

  for (var impIdx = 0; impIdx < impList.length; impIdx++) {

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
    // 方法列表
    let regularExp = /[-,\+]+\s?\([a-zA-Z]*\s*\**\s*\)/igm;
    let methodBeginList = methodContent.match(regularExp);

    if (methodBeginList.length == 0) {
      // 该类没有方法
      continue;
    } else {
      var curMethodContent = methodContent;
      for (let idx = 0; idx < methodBeginList.length; idx++) {
        let methodBeginStr = methodBeginList[idx];
        let isClassMethod = (methodBeginStr.indexOf("-") == -1);

        if (methodBeginList.length == 1) {
          classAcpset = addClassAcpset(className, isClassMethod, curMethodContent, JPAspect.Aspects);
        } else {

          if (idx == 0) {
            continue;
          }

          let methodIdx =  curMethodContent.indexOf(methodBeginStr);
          let methodString = curMethodContent.substring(0, methodIdx);
          classAcpset = addClassAcpset(className, isClassMethod, methodString, JPAspect.Aspects);
        
          curMethodContent = curMethodContent.substring(methodIdx);
          if (idx == (methodBeginList.length - 1)) {
            classAcpset = addClassAcpset(className, isClassMethod, curMethodContent, JPAspect.Aspects);
          }
        }
      }
    }
  }

  return JSON.stringify(JPAspect, null, 4);
}

function addClassAcpset(className, isClassMethod, methodString, Aspects)
{
  methodString = methodString.trim();

  if (methodString.length == 0) {
    return;
  }

  var classAcpset = {
    className: className,
    selName: "",
    isClassMethod: isClassMethod,
    hookType: 1,
    argumentNames: [],
    customMessages: []
  };

  Aspects.push(classAcpset);
}

function converterMethodToMessage(methodString)
{
  var aspectMessageList = [];

  var aspectMessage = {
    message: "",
    invokeCondition: {},
    messageType: 0,
    arguments: {},
    localInstanceKey: "",
  };

  return aspectMessageList;
}
