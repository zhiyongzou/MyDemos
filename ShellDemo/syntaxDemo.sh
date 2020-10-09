#!/bin/sh

#【注意】shell 变量名和等号之间不能有空格
# 变量使用：变量名前加美元符 $
# {} 花括号用来确定变量名边界

my_string='helloWorld'
my_string1="prifix 1 ${my_string}"
my_string2='prifix 2 ${my_string}'
echo ${my_string1}'\n'${my_string2}

#变量名的命名规则
#1.命名只能使用英文字母，数字和下划线，首个字符不能以数字开头。
#2.中间不能有空格，可以使用下划线（_）。
#3.不能使用标点符号。
#4.不能使用bash里的关键字（可用help命令查看保留关键字）

# 标点符号
	# *illegal_string='23hu'
#数字开头
	# 1illegal_string1='23hu'
#空格
	#illegal string2='23hu'
# 关键字
pwd='23hu'
echo ${pwd}