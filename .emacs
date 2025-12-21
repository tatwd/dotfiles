;; 
;; window: $env:APPDATA/.emacs.d/init.el
;; example link this file:
;;   sudo powershell -Command "New-Item -ItemType SymbolicLink -Path '$env:APPDATA\.emacs.d\init.el' -Target '$PWD\.emacs'"
;;

;; disable startup screen
(setq inhibit-startup-screen t)

(setq initial-buffer-choice t)

;; simple setup theme
;;(load-theme 'modus-vivendi-tritanopia t)

;; set default font
(set-face-attribute 'default nil :font "Maple Mono NF CN" :height 130)


(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)

;;hide window title bar
;;(setq default-frame-alist '((undecorated . t)))

(setq initial-frame-alist '((width . 80) (height . 30)))


;; show relative line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)
;;(setq line-number-mode t)

