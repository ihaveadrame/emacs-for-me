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

;; Python 设置
(defun my-python-mode-config ()
  (setq python-indent-offset 4
        python-indent 4
        indent-tabs-mode nil
        default-tab-width 4

        ;; 设置 run-python 的参数
        python-shell-interpreter "ipython"
        python-shell-interpreter-args "-i"
        python-shell-prompt-regexp "In \\[[0-9]+\\]: "
        python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
        python-shell-completion-setup-code "from IPython.core.completerlib import module_completion"
        python-shell-completion-module-string-code "';'.join(module_completion('''%s'''))\n"
        python-shell-completion-string-code "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

  (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;; 树形目录 
  (add-to-list 'package-archives
			   '("melpa" . "http://melpa.org/packages/"))
  
  (hs-minor-mode t)                     ;开启 hs-minor-mode 以支持代码折叠
  (auto-fill-mode 0)                    ;关闭 auto-fill-mode，拒绝自动折行
  (whitespace-mode 0)                   ;开启 whitespace-mode 对制表符和行为空格高亮 关闭吧 有问题再开
  (hl-line-mode t)                      ;开启 hl-line-mode 对当前行进行高亮
  (pretty-symbols-mode t)               ;开启 pretty-symbols-mode 将 lambda 显示成希腊字符 λ
  (set (make-local-variable 'electric-indent-mode) nil)) ;关闭自动缩进

(add-hook 'python-mode-hook 'my-python-mode-config)

;; global


;; Add Packages
 (defvar my/packages '(
		;; --- Auto-completion ---
		company
		;; --- Better Editor ---
		hungry-delete
		swiper
		counsel
		smartparens
		;; --- Major Mode ---
		js2-mode
		;; --- Minor Mode ---
		nodejs-repl
		exec-path-from-shell
		;; --- Themes ---
		monokai-theme
		;; solarized-theme
		) "Default packages")

 (setq package-selected-packages my/packages)

 (defun my/packages-installed-p ()
     (loop for pkg in my/packages
	   when (not (package-installed-p pkg)) do (return nil)
	   finally (return t)))

 (unless (my/packages-installed-p)
     (message "%s" "Refreshing package database...")
     (package-refresh-contents)
     (dolist (pkg my/packages)
       (when (not (package-installed-p pkg))
	 (package-install pkg))))

 ;; Find Executable Path on OS X
 (when (memq window-system '(mac ns))
   (exec-path-from-shell-initialize))

;; 设置默认全屏
(setq initial-frame-alist (quote ((fullscreen . maximized))))

;; 钩子设置自动匹配括号
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)

;; 高亮当前行
(global-hl-line-mode 1)

;;安装主题
(add-to-list 'my/packages 'monokai-theme)
(load-theme 'monokai 1)

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


(when (not (require 'company-jedi nil :noerror))
  (message "install company-jedi now...")
  (setq url-http-attempt-keepalives nil)
  (package-refresh-contents)
  (package-install 'company-jedi))

;; python模式使用虚拟环境
(setq jedi:environment-root "jedi")
(setq jedi:server-command (jedi:-env-server-command))

(defun config/enable-jedi ()
  (add-to-list 'company-backends 'company-jedi))
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'config/enable-jedi)

;; python点补全
(setq jedi:complete-on-dot t)

;; python 别名补全
(setq jedi:use-shortcuts t)

;; 最小补全字数
(setq compandy-minimum-prefix-length 3)

;; 设置补全列表左右对齐
(setq company-tooltip-align-annotations t)

;; 补全列表 高频词汇优先
(setq company-transformers '(company-sort-by-occurrence))

;; 补全列表循环
(setq company-selection-wrap-around t)

;;补全列表中  使用C-n C-p 代替 M-n M-p
(define-key company-active-map (kbd "M-n") nil)
(define-key company-active-map (kbd "M-p") nil)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)

(define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "S-TAB") 'company-select-previous)
(define-key company-active-map (kbd "<backtab>") 'company-select-previous)


(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))


;; 安装 flycheck
(when (not (require 'flycheck nil :noerror))
  (message "install flycheck now...")
  (setq url-http-attempt-keepalives nil)
  (package-refresh-contents)
  (package-install 'flycheck))

;;
(defun config/enable-flycheck ()
  (flycheck-mode t))
(add-hook 'python-mode-hook 'config/enable-flycheck)

(defcustom flycheck-executable-find #'executable-find
  "Function to search for executables.

The value of this option is a function which is given the name or
path of an executable and shall return the full path to the
executable, or nil if the executable does not exit.

The default is the standard `executable-find' function which
searches `exec-path'.  You can customize this option to search
for checkers in other environments such as bundle or NixOS
sandboxes."
  :group 'flycheck
  :type '(choice (const :tag "Search executables in `exec-path'" executable-find)
                 (function :tag "Search executables with a custom function"))
  :package-version '(flycheck . "0.25")
  :risky t)

(defun executable-find (command)
  "Search for COMMAND in `exec-path' and return the absolute file name.
Return nil if COMMAND is not found anywhere in `exec-path'."
  ;; Use 1 rather than file-executable-p to better match the behavior of
  ;; call-process.
  (locate-file command exec-path exec-suffixes 1))

;; (push "/usr/local/bin/" exec-path)

(when (not (require 'auto-virtualenvwrapper nil :noerror))
  (message "install auto-virtualenvwrapper now...")
  (setq url-http-attempt-keepalives nil)
  (package-refresh-contents)
  (package-install 'auto-virtualenvwrapper))

(add-hook 'python-mode-hook  #'auto-virtualenvwrapper-activate)
(add-hook 'window-configuration-change-hook  #'auto-virtualenvwrapper-activate)


(declare-function python-shell-calculate-exec-path "python")

(defun flycheck-virtualenv-executable-find (executable)
  "Find an EXECUTABLE in the current virtualenv if any."
  (if (bound-and-true-p python-shell-virtualenv-root)
      (let ((exec-path (python-shell-calculate-exec-path)))
        (executable-find executable))
    (executable-find executable)))

(defun flycheck-virtualenv-setup ()
  "Setup Flycheck for the current virtualenv."
  (setq-local flycheck-executable-find #'flycheck-virtualenv-executable-find))


(when (not (require 'py-autopep8 nil :noerror))
  (message "install autopep8 now...")
  (setq url-http-attempt-keepalives nil)
  (package-refresh-contents)
  (package-install 'py-autopep8))

(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
(setq py-autopep8-options '("--max-line-length=79"))


;; 以下是安装包后配置
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(google-translate-default-source-language "en")
 '(package-selected-packages
   (quote
    (anaconda-mode ggtags elpy company-jedi jedi-core ## neotree window-numbering smex hungry-delete company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'scroll-left 'disabled nil)

(require 'google-translate)
(require 'google-translate-default-ui)
(global-set-key "\C-ct" 'google-translate-at-point)
(global-set-key "\C-cT" 'google-translate-query-translate)

