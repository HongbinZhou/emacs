
;;; Time stamp
;;打开time-stamp功能，将time-stamp加入write-file-hooks，就能在每次保存
;;文件时自动更新time-stamp
;;在文件的前8行插入如下标识符
;;Time-stamp: <Modified by hbzhou Time：2013-04-09 16:59:43>
;;或者
;;Time-stamp: " "
;;注意：Time-stamp第一个字母必须大写，Time-stamp：后面必须有一个空格。这样设置后就可以在每次修改文件时自动更新文件的修改时间了。
(add-hook 'write-file-hooks 'time-stamp)

(setq time-stamp-line-limit 20)
;(setq time-stamp-start "Last \\(modified\\|revised\\): +")
;(setq time-stamp-end "\\( .*\\)?$")


;;设置time-stamp格式
;;说明：
;; %:u，更新时用登录Linux的用户名替换
;; %04y-%02m-%02d，更新时以“YYYY-MM-DD”的格式显示年月日
;; %02H:%02M:%02S，更新时以“HH:MM:SS”的格式显示时分秒
(setq time-stamp-format
      "Modified by %:u Time：%04y-%02m-%02d %02H:%02M:%02S"
      time-stamp-active t
      time-stamp-warn-inactive t)
