;;; package --- summary or add python emacs mode: elpy
;; add repository

(require 'package)
(setq package-archives '(
             ("gnu" . "http://elpa.gnu.org/packages/")
             ("melpa" . "http://melpa.milkbox.net/packages/")
             ))
(add-to-list 'package-archives
         '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq slime-contribs '(slime-fancy))
(require 'slime-autoloads)

;; automatical complete: company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode); global enable
(setq company-show-numbers t); display serial number
(setq company-idle-delay 0.2); menu delay
(setq company-minimum-prefix-length 1); start completelyness number




;; -----------------------------------  下面是基础设置 -------------------
;;主题
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'dracula t)
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



;; --------------------------------  下面是python工作常用配置 --------------------------
;; 自动补全
(require 'company)
(global-company-mode t); 全局开启

(setq company-idle-delay 0.2;菜单延迟
      company-minimum-prefix-length 1; 开始补全字数
      company-require-match nil
      company-dabbrev-ignore-case nil
      company-dabbrev-downcase nil
      company-show-numbers t; 显示序号
      company-transformers '(company-sort-by-backend-importance)
      company-continue-commands '(not helm-dabbrev)
      )
                    ; 补全后端使用anaconda
(add-to-list 'company-backends '(company-anaconda :with company-yasnippet))
                    ; 补全快捷键
(global-set-key (kbd "<C-tab>") 'company-complete)
                    ; 补全菜单选项快捷键
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
;(setenv "PATHONPATH" "/usr/local/Cellar/python/3.7.0/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages")
;; 在python模式中自动启用
(add-hook 'python-mode-hook 'anaconda-mode)

;(setq python-shell-interpreter "python"
;      python-shell-interpreter-args "-i")

;(defun my/python-mode-hook ()
 ; (add-to-list 'company-backends 'company-jedi))

;(add-hook 'python-mode-hook 'my/python-mode-hook)

;; elpy-- main actor
(require 'elpy)
(package-initialize)
(defalias 'workon 'pyvenv-workon)
;; enable elpy jedi backend
;(setq elpy-rpc-backend "jedi")
(setq elpy-rpc-python-command "python")
(setq python-shell-interpreter "python")
(setq pyvenv-virtualenvwrapper-python "/usr/bin/python")
(elpy-enable)
;; Fixing a key binding bug in elpy
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
;; Fixing another key binding bug in iedit mode
(define-key global-map (kbd "C-c o") 'iedit-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)
;; grammal check: flycheck
;;(add-hook 'after-init-hook #'global-flycheck-mode);global enable
                    ; close flymake,  start flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules(delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; virutal environment:  virtualenvwrapper
(require 'virtualenvwrapper)
(venv-initialize-interactive-shells)
(venv-initialize-eshell)
(setq venv-location "~/.virtualenvs/"); setup virtual environment folder
;; if there multiple folder:
;; (setq venv-location '("~/myvenv-1/"
;;                       "~/myvenv-2/"))
;; M-x venv-workon open virtual environment
;; if `venv-workon` not work, try to run  M-x pyvenv-activate -> choic your venv
;;; Commentary:




;; ------------------------ org-mode设置 ------------------------------------
(require 'cl)
(require 'window-numbering)
(window-numbering-mode 1)
(winner-mode 1)
;; copied from http://puntoblogspot.blogspot.com/2011/05/undo-layouts-in-emacs.html
(global-set-key (kbd "C-x 4 u") 'winner-undo)
(global-set-key (kbd "C-x 4 r") 'winner-redo)
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
 '(custom-safe-themes
   (quote
    ("a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" default)))
 '(epg-gpg-program "/usr/local/bin/gpg2")
 '(google-translate-default-source-language "en")
 '(js-indent-level 2)
 '(package-selected-packages
   (quote
    (company-anaconda emmet-mode wgrep-ag rg vue-mode vue-html-mode slime move-line dracula-theme elpygen window-numbering smex smartparens py-autopep8 nodejs-repl neotree monokai-theme material-theme hungry-delete htmlize ggtags flycheck exec-path-from-shell elpy ein counsel company-jedi better-defaults auto-virtualenvwrapper anaconda-mode))))
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

(add-hook 'org-mode-hook
	  (lambda () (setq truncate-lines nil)))

;; ----------------------- gtag =todo= ---------------------------------------------

(with-eval-after-load 'python
  (defun python-shell-completion-native-try ()
    "Return non-nil if can trigger native completion."
    (let ((python-shell-completion-native-enable t)
          (python-shell-completion-native-output-timeout
           python-shell-completion-native-try-output-timeout))
      (python-shell-completion-native-get-completions
       (get-buffer-process (current-buffer))
       nil "_"))))

;; ---------------------- emacs js mode
;(setq vue-mode-packages
;  '(vue-mode))

;(setq vue-mode-excluded-packages '())

;(defun vue-mode/init-vue-mode (
;  "Initialize my package"
;  (use-package vue-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;;自动补全html标签

;; ------------------------ org-mode设置 ------------------------------------
(require 'cl)
(require 'window-numbering)
(window-numbering-mode 1)
(winner-mode 1)
;; copied from http://puntoblogspot.blogspot.com/2011/05/undo-layouts-in-emacs.html
(global-set-key (kbd "C-x 4 u") 'winner-undo)
(global-set-key (kbd "C-x 4 r") 'winner-redo)
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
               "** TODO %^{书名}\n%u\n%a\n" :clock-in t :clock-resume t))
(add-to-list 'org-capture-templates
             '("tw" "Work Task" entry
               (file+headline "~/Dropbox/org/task.org" "Work")
               "** TODO %^{任务名}\n%u\n%a\n" :clock-in t :clock-resume t))

(add-to-list 'org-capture-templates
             '("j" "Journal" entry (file+weektree "~/Dropbox/org/journal.org")
               "** %U - %^{heading}\n  %?"))

(add-to-list 'org-capture-templates
             '("i" "Inbox" entry (file "~/Dropbox/org/inbox.org")
               "** %U - %^{heading} %^g\n %?\n"))

(add-to-list 'org-capture-templates
             '("n" "Notes" entry (file "~/Dropbox/org/notes/inbox.org")
               "** %^{heading} %t %^g\n  %?\n"))

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

(add-hook 'org-mode-hook
	  (lambda () (setq truncate-lines nil)))

;; ----------------------- gtag =todo= ---------------------------------------------

(with-eval-after-load 'python
  (defun python-shell-completion-native-try ()
    "Return non-nil if can trigger native completion."
    (let ((python-shell-completion-native-enable t)
          (python-shell-completion-native-output-timeout
           python-shell-completion-native-try-output-timeout))
      (python-shell-completion-native-get-completions
       (get-buffer-process (current-buffer))
       nil "_"))))

;; ---------------------- emacs js mode
;(setq vue-mode-packages
;  '(vue-mode))

;(setq vue-mode-excluded-packages '())

;(defun vue-mode/init-vue-mode (
;  "Initialize my package"
;  (use-package vue-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; 设置web缩进
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  ;; indent setting
  (setq web-mode-markup-indent-offset 2)
  ;; comment style setting
  (setq web-mode-comment-style 2))
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; 设置js2-mode 缩进2
;; 不能动态的设置，只能通过 M-x customize-variable -> 输入js2-basic-offset -> 设置缩进为2保存退出


;; 设置快捷键 调用外部浏览器打开页面
(define-key web-mode-map (kbd "C-c C-v") 'browse-url-of-file)

;;自动补全html标签
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'html-mode-hook 'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)
;; ---------------------- 全局查找
(require 'rg)
(rg-enable-default-bindings (kbd "M-s"))
(add-hook 'rg-mode-hook 'wgrep-ag-setup)
;; ---------------------- emacs其他调整自动写入配置

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
