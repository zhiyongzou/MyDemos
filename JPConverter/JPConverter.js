//
//
//  JPConverter.js
//
//  Created by zzyong on 2020/03/20.
//  Copyright © 2020 zzyong. All rights reserved.
//

function tabKeyClick(obj) {
    if (event.keyCode == 9)
    {
       obj.value = obj.value + "    ";
       event.returnValue = false;
    }
  }

function didConverterButtonClick() {
    console.log("didConverterButtonClick");
}
