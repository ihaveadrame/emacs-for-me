(when (>= emacs-major-version 24)
     (require 'package)
     (package-initialize)
     (setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
			      ("melpa" . "http://elpa.emacs-china.org/melpa/"))))

(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize) ;; You might already have this line

;; cl - Common Lisp Extension
(require 'cl)

(require 'window-numbering)
(window-numbering-mode 1)

(winner-mode 1)
;; copied from http://puntoblogspot.blogspot.com/2011/05/undo-layouts-in-emacs.html
(global-set-key (kbd "C-x 4 u") 'winner-undo)
(global-set-key (kbd "C-x 4 r") 'winner-redo)

;; python 代码跳转
;(add-hook 'python-mode-hook 'anaconda-mode)
;(add-hook 'python-mode-hook 'anaconda-eldoc-mode)

(add-hook 'python-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'python-mode)
              (ggtags-mode 1))))
;;配置gtags  
; (add-to-list 'load-path "~/emacs/global")  
;(autoload 'gtags-mode "gtags" "" t)  
;(setq c-mode-hook '(lambda ()  
;            (gtags-mode 1)))  
;(global-set-key (kbd "C-c g f") 'gtags-find-tag)  
;(global-set-key (kbd "C-c g p") 'gtags-pop-stack)  
;(global-set-key (kbd "C-c g s") 'gtags-select-tag)

;; org-mode
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
(setq org-export-backends (quote (ascii html icalendar latex md)))
;; 设置org-model 插入源代码
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (python . t)
   (C . t)
   ))

;; 设置org-capture 最小配置
(require 'org)
(setq org-export-default-language "zh-CN")
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-export-with-sub-superscripts (quote {}))
(setq org-default-notes-file "~/org/inbox.org")
(setq org-capture-templates nil)

(add-to-list 'org-capture-templates '("t" "Tasks"))
(add-to-list 'org-capture-templates
             '("tr" "Book Reading Task" entry
               (file+olp "~/Dropbox/org/task.org" "Reading" "Book")
               "* TODO %^{书名}\n%u\n%a\n" :clock-in t :clock-resume t))
(add-to-list 'org-capture-templates
             '("tw" "Work Task" entry
               (file+headline "~/Dropbox/org/task.org" "Work")
               "* TODO %^{任务名}\n%u\n%a\n" :clock-in t :clock-resume t))

(add-to-list 'org-capture-templates
             '("j" "Journal" entry (file+weektree "~/Dropbox/org/journal.org")
               "* %U - %^{heading}\n  %?"))

(add-to-list 'org-capture-templates
             '("i" "Inbox" entry (file "~/Dropbox/org/inbox.org")
               "* %U - %^{heading} %^g\n %?\n"))

(add-to-list 'org-capture-templates
             '("n" "Notes" entry (file "~/Dropbox/org/notes/inbox.org")
               "* %^{heading} %t %^g\n  %?\n"))

(add-to-list 'org-capture-templates
	     '("b" "Billing" plain
	       (file+function "~/Dropbox/org/billing.org" find-month-tree)
	       " | %U | %^{类别} | %^{描述} | %^{金额} | " :kill-buffer t))

(defun get-year-and-month ()
  (list (format-time-string "%Y年") (format-time-string "%m月")))


(defun find-month-tree ()
  (let* ((path (get-year-and-month))
         (level 1)
         end)
    (unless (derived-mode-p 'org-mode)
      (error "Target buffer \"%s\" should be in Org mode" (current-buffer)))
    (goto-char (point-min))             ;移动到 buffer 的开始位置
    ;; 先定位表示年份的 headline，再定位表示月份的 headline
    (dolist (heading path)
      (let ((re (format org-complex-heading-regexp-format
                        (regexp-quote heading)))
            (cnt 0))
        (if (re-search-forward re end t)
            (goto-char (point-at-bol))  ;如果找到了 headline 就移动到对应的位置
          (progn                        ;否则就新建一个 headline
            (or (bolp) (insert "\n"))
            (if (/= (point) (point-min)) (org-end-of-subtree t t))
            (insert (make-string level ?*) " " heading "\n"))))
      (setq level (1+ level))
      (setq end (save-excursion (org-end-of-subtree t t))))
    (org-end-of-subtree)))


(require 'epa-file)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(epg-gpg-program "/usr/local/bin/gpg2")
 '(google-translate-default-source-language "en")
 '(package-selected-packages
   (quote
    (htmlize anaconda-mode ggtags elpy company-jedi jedi-core ## neotree window-numbering smex hungry-delete company))))
(epa-file-enable)
(setq epa-file-select-keys 0)
(setq epa-file-cache-passphrase-for-symmetric-encryption t)


(add-to-list 'org-capture-templates
             '("p" "Passwords" entry (file "~/Dropbox/org/passwords.org.gpg")
               "* %U - %^{title} %^G\n\n  - 用户名: %^{用户名}\n  - 密码: %^{密码}"
               :empty-lines 1 :kill-buffer t))


(require 'ox-publish)
(setq org-publish-project-alist
      '(
    ("org-linusp"
     ;; Path to your org files.
     :base-directory "~/Dropbox/org/notes/"
     :base-extension "org"
     ;; Path to your Jekyll project.
     :publishing-directory "~/Dropbox/org/jekyll_blog/ihaveadrame.github.io/_posts/"
     :recursive t
     :publishing-function org-html-publish-to-html
     :headline-levels 4
     :html-extension "html"
     :body-only t ;; Only export section between <body> </body>
     )
    ("org-static-linusp"
     :base-directory "~/blog/org/"
     :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|php"
     :publishing-directory "~/blog/Jekyll/"
     :recursive t
     :publishing-function org-publish-attachment
     )
    ("blog-linusp" :components ("org-linusp" "org-static-linusp"))
    ))



;; 设置中文字体
(setq face-font-rescale-alist '(("宋体" . 1.2)
                                    ("微软雅黑" . 1.2)
                                    ("Microsoft Yahei" . 1.2)
                                    ("WenQuanYi Zen Hei" . 1.2)))

 ;; Find Executable Path on OS X
 (when (memq window-system '(mac ns))
   (exec-path-from-shell-initialize))

;; 设置默认全屏
(setq initial-frame-alist (quote ((fullscreen . maximized))))

;; 钩子设置自动匹配括号
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)

;; 高亮当前行
(global-hl-line-mode 1)

;; 关闭工具栏， tool-bar-mode
(tool-bar-mode -1)

;; 关掉文件滑动控件
(scroll-bar-mode -1)

;;显示行号
(global-linum-mode 1)

;; 更改光标样式（不能生效 解决方案第二章）
(setq-default cursor-type 'bar)

;;关闭启动帮助画面
(setq inhibit-splash-screen 1)

;; 更改字体大小 16pt
(set-face-attribute 'default nil :height 160)

;; 关闭自动备份文件功能
(setq make-backup-files nil)

;;快速打开配置文件
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; 这一行代码将函数 open-init-file 绑定到<f2>键上
(global-set-key (kbd "<f2>") 'open-init-file)

;;开启全局company补全
(global-company-mode 1)

;; 图形界面菜单 最近编辑过的文件
(require 'recentf)
(setq recentf-max-menu-item 10)


;; 设置选中后输入替换原始文本
(delete-selection-mode 1)

;; 切换默认的js mode
(setq auto-mode-alist
      (append
       '(("\\.js\\'" . js2-mode))
       auto-mode-alist))


(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; -------------------- python代码补全相关-----------------------
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    ein
    elpy
    flycheck
    material-theme
    py-autopep8))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

;; PYTHON CONFIGURATION
;; --------------------------------------

(elpy-enable)
(elpy-use-ipython)

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; init.el ends here
