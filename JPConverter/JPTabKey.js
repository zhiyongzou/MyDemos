//
//
//  JPTabKey.js
//
//  Created by zzyong on 2020/03/20.
//  Copyright © 2020 zzyong. All rights reserved.
//

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

// 指定位置插入字符串
function insertString(soure, toIndex, newStr)
{   
  return soure.slice(0, toIndex) + newStr + soure.slice(toIndex);
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