;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "Mateus"
      user-mail-address "Bernardo-HarringtonG@cardiff.ac.uk")

(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…"                ; Unicode ellispis are nicer than "...", and also save /precious/ space
      password-cache-expiry nil                   ; I can trust my computers ... can't I?
      ;; scroll-preserve-screen-position 'always     ; Don't have `point' jump around
      scroll-margin 2)                            ; It's nice to maintain a little margin

(display-time-mode 1)                             ; Enable time in the mode-line

(unless (string-match-p "^Power N/A" (battery))   ; On laptops...
  (display-battery-mode 1))                       ; it's nice to know how much power you have

(global-subword-mode 1)                           ; Iterate through CamelCase words

(setq doom-font (font-spec :family "Source Code Pro" :size 18)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 19)
      doom-big-font (font-spec :family "Source Code Pro" :size 24))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'modus-vivendi)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(map! :leader
      :desc "Swiper" "b f" #'swiper
      :desc "evil-comment" "b /" #'evilnc-comment-or-uncomment-lines)

;; another example:
;; (map! :leader
;;       (:prefix-map ("a" . "applications")
;;        (:prefix ("j" . "journal")
;;         :desc "New journal entry" "j" #'org-journal-new-entry
;;         :desc "Search journal entry" "s" #'org-journal-search)))

(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file" "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-open-file ; use dired-find-file instead of dired-open.
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill ; copies filename to kill ring.
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-up-directory
  (kbd "% l") 'dired-downcase
  (kbd "% u") 'dired-upcase
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
;; Get file icons in dired
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))

(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(require 'org)
(require 'org-habit)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq
 org_notes (concat (getenv "HOME") "/Documents/org-roam/")
 ;; zot_bib (concat (getenv "HOME") "/Documents/masterLib.bib")
 org-directory org_notes
 ;; org-roam-dailies-directory (concat org_notes "daily")
 deft-directory org_notes
 org-roam-directory org_notes
 org-roam-db-location (concat org_notes "org-roam.db"))

;; (setq mh/default-bibliography `(,(expand-file-name "masterLib.bib" org-directory)))
(setq mh/default-bibliography `("~/Documents/masterLib.bib"))

(setq org-agenda-files
      '("~/Documents/org/tasks.org"
        "~/Documents/org/habits.org"
        "~/Documents/org/birthdays.org"))

;; set default org-babel header-args
;; (setq org-babel-default-header-args
;;       (cons '(:exports . "both")
;;             (assq-delete-all :exports org-babel-default-header-args))
;;       org-babel-default-header-args
;;       (cons '(:results . "output verbatim replace")
;;             (assq-delete-all :results org-babel-default-header-args)))

(require 'org-habit)
(add-to-list 'org-modules 'org-habit)
(setq org-habit-graph-column 60)

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
        (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

(setq org-refile-targets
      '(("archive.org" :maxlevel . 1)
        ("tasks.org" :maxlevel . 1)))

;; Save Org buffers after refiling!
(advice-add 'org-refile :after 'org-save-all-org-buffers)

(setq org-tag-alist
      '((:startgroup)
        ;; Put mutually exclusive tags here
        (:endgroup)
        ("@errand" . ?E)
        ("@home" . ?H)
        ("@work" . ?W)
        ("agenda" . ?a)
        ("planning" . ?p)
        ("publish" . ?P)
        ("batch" . ?b)
        ("note" . ?n)
        ("idea" . ?i)))

;; Configure custom agenda views
(setq org-agenda-custom-commands
      '(("d" "Dashboard"
         ((agenda "" ((org-deadline-warning-days 7)))
          (todo "NEXT"
                ((org-agenda-overriding-header "Next Tasks")))
          (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

        ("n" "Next Tasks"
         ((todo "NEXT"
                ((org-agenda-overriding-header "Next Tasks")))))
        ;; filter to tag work, but not tag email
        ("W" "Work Tasks" tags-todo "+work-email")

        ;; Low-effort next actions
        ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
         ((org-agenda-overriding-header "Low Effort Tasks")
          (org-agenda-max-todos 20)
          (org-agenda-files org-agenda-files)))

        ("w" "Workflow Status"
         ((todo "WAIT"
                ((org-agenda-overriding-header "Waiting on External")
                 (org-agenda-files org-agenda-files)))
          (todo "REVIEW"
                ((org-agenda-overriding-header "In Review")
                 (org-agenda-files org-agenda-files)))
          (todo "PLAN"
                ((org-agenda-overriding-header "In Planning")
                 (org-agenda-todo-list-sublevels nil)
                 (org-agenda-files org-agenda-files)))
          (todo "BACKLOG"
                ((org-agenda-overriding-header "Project Backlog")
                 (org-agenda-todo-list-sublevels nil)
                 (org-agenda-files org-agenda-files)))
          (todo "READY"
                ((org-agenda-overriding-header "Ready for Work")
                 (org-agenda-files org-agenda-files)))
          (todo "ACTIVE"
                ((org-agenda-overriding-header "Active Projects")
                 (org-agenda-files org-agenda-files)))
          (todo "COMPLETED"
                ((org-agenda-overriding-header "Completed Projects")
                 (org-agenda-files org-agenda-files)))
          (todo "CANC"
                ((org-agenda-overriding-header "Cancelled Projects")
                 (org-agenda-files org-agenda-files)))))))

(setq org-capture-templates
      `(("t" "Tasks / Projects")
        ("tt" "Task" entry (file+olp "~/Documents/org/tasks.org" "Inbox")
         "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
        ("ts" "Clocked Entry Subtask" entry (clock)
         "* TODO %\n %U\n %a\n %i" :empty-lines 1)

        ("j" "Journal Entries")
        ("jj" "Journal" entry
         (file+olp+datetree "~/Documents/org/journal.org")
         "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
         ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
         :clock-in :clock-resume
         :empty-lines 1)
        ("jm" "Meeting" entry
         (file+olp+datetree "~/Documents/org/journal.org")
         "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
         :clock-in :clock-resume
         :empty-lines 1)

        ("w" "Workflows")
        ("we" "Checking Email" entry (file+olp+datetree "~/Documents/org/journal.org")
         "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

        ("h" "Hugo")
        ("hp" "Blog Post" entry (file+olp "~/git_work/personal_website/org-content/blog.org" "Posts")
         (function  org-hugo-new-subtree-post-capture-template))

        ("m" "Metrics Capture")
        ("mw" "Weight" table-line (file+headline "~/Documents/org/metrics.org" "Weight")
         "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

;; this is an example of how to bind staight to a capture template
;; (define-key global-map (kbd "C-c j")
;; (lambda () (interactive) (org-capture nil "jj")))

;; (efs/org-font-setup))

(setq org-check-running-clock t
      org-log-note-clock-out t
      org-log-done 'time
      org-log-into-drawer t)
      ;; org-clock-auto-clockout-timer (* 10 60))

(with-eval-after-load 'org
  ;; This is needed as of Org 9.2
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("sq" . "src sql"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
  (add-to-list 'org-structure-template-alist '("json" . "src json"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("r" . "src R")))

(use-package yasnippet
  :init
  (yas-global-mode 1)
  ;;:diminish yas-mode
  :config
  (require 'warnings)
  (add-to-list 'warning-suppress-types '(yasnippet backquote-change))
  ;; (setq yas-snippet-dirs
  ;;       '("~/.config/doom/snippets"                 ;; personal snippets
  ;;         ;; "/path/to/some/collection/"           ;; foo-mode and bar-mode snippet collection
  ;;         ;; "/path/to/yasnippet/yasmate/snippets" ;; the yasmate collection
  ;;         ))
  ;;(setq yas-snippet-dirs-custom (format "%s/%s" user-emacs-directory "snippets/"))
  ;; (setq yas-snippet-dirs-custom (expand-file-name "/snippets" user-emacs-directory))
  ;; (add-to-list' yas-snippet-dirs 'yas-snippet-dirs-custom)
  (setq yas-indent-line t)
  ;; install some snippets
  ;; (use-package yasnippet-snippets)
  (yas-reload-all))

;; ivy support
;; (use-package ivy-yasnippet)
;; this doesn't seem to work - yasnippets in general not working well in R
(use-package r-autoyas
  :hook (ess-mode-hook . r-autoyas-ess-active))
;; (require 'r-autoyas)
;; (add-hook 'ess-mode-hook 'r-autoyas-ess-activate)

(use-package! org-roam
  :init
  (map! :leader
        :prefix "n r"
        ;; :desc "org-roam" "l" #'org-roam-buffer-toggle
        ;; :desc "org-roam-node-insert" "i" #'org-roam-node-insert
        ;; :desc "org-roam-node-find" "f" #'org-roam-node-find
        ;; :desc "org-roam-ref-find" "r" #'org-roam-ref-find
        ;; :desc "org-roam-capture" "c" #'org-roam-capture
        :desc "org-roam-show-graph" "g" #'org-roam-ui-mode
        :desc "org-roam-citation" "c" #'mh/org-roam-node-from-cite
        :desc "jethro/org-capture-slipbox" "<tab>" #'jethro/org-capture-slipbox)
  (setq org-roam-db-gc-threshold most-positive-fixnum
        org-id-link-to-org-use-id t)
  :config
  (org-roam-db-autosync-mode +1)
  (set-popup-rules!
    `((,(regexp-quote org-roam-buffer) ; persistent org-roam buffer
       :side right :width .33 :height .5 :ttl nil :modeline nil :quit nil :slot 1)
      ("^\\*org-roam: " ; node dedicated org-roam buffer
       :side right :width .33 :height .5 :ttl nil :modeline nil :quit nil :slot 2)))
  (add-hook 'org-roam-mode-hook #'turn-on-visual-line-mode)
  (setq org-roam-capture-templates
        '(("m" "main" plain
           "%?"
           :if-new (file+head "main/${slug}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n#+filetags: Project")
           :unnarrowed t)
          ("r" "reference" plain "%?"
           :if-new
           (file+head "reference/${slug}.org" "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("a" "article" plain "%?"
           :if-new
           (file+head "articles/${slug}.org" "#+title: ${title}\n#+filetags: :article:\n")
           :immediate-finish t
           :unnarrowed t)))

  (defun jethro/tag-new-node-as-draft ()
    (org-roam-tag-add '("draft")))

  (add-hook 'org-roam-capture-new-node-hook #'jethro/tag-new-node-as-draft)
  (set-company-backend! 'org-mode '(company-capf))

  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
        (file-name-nondirectory
         (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))

  (setq org-roam-node-display-template
        (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))

  (require 'citar)


  (defun mh/org-roam-node-from-cite (keys-entries)
    (interactive (list (citar-select-ref :multiple nil :rebuild-cache t)))
    (let ((title (citar--format-entry-no-widths (cdr keys-entries)
                                                "${title}")))
      (org-roam-capture- :templates
                         '(("r" "reference" plain "%?" :if-new
                            (file+head "reference/${citekey}.org"
                                       ":PROPERTIES:
:ROAM_REFS: [cite:@${citekey}]
:END:
#+title: ${title}\n")
                            :immediate-finish t
                            :unnarrowed t))
                         :info (list :citekey (car keys-entries))
                         :node (org-roam-node-create :title title)
                         :props '(:finalize find-file)))))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(after! bibtex-completion
  (setq! bibtex-completion-notes-path org-roam-directory
         bibtex-completion-bibliography mh/default-bibliography
         org-cite-global-bibliography mh/default-bibliography
         bibtex-completion-pdf-field "file"))

(after! bibtex-completion
  (after! org-roam
    (setq! bibtex-completion-notes-path org-roam-directory)))

(after! citar
  (map! :map org-mode-map
        :desc "Insert citation" "C-c b" #'citar-insert-citation)
  (setq citar-bibliography mh/default-bibliography
        citar-at-point-function 'embark-act
        citar-symbol-separator "  "
        citar-format-reference-function 'citar-citeproc-format-reference
        org-cite-csl-styles-dir "~/Zotero/styles"
        citar-citeproc-csl-styles-dir org-cite-csl-styles-dir
        citar-citeproc-csl-locales-dir "~/Zotero/locales"
        citar-citeproc-csl-style (org-file-name-concat org-cite-csl-styles-dir "apa.csl")))

(defun efs/insert-r-pipe ()
  "Insert the pipe operator in R, %>%"
  (interactive)
  (just-one-space 1)
  (insert "%>%")
  (reindent-then-newline-and-indent))

(defun efs/insert-r-in ()
  "Insert the pipe operator in R, %>%"
  (interactive)
  (just-one-space 1)
  (insert "%in%")
  (reindent-then-newline-and-indent))
;; <<- operator
(defun efs/insert_double_assign_operator ()
  "R - <<- operator"
  (interactive)
  (just-one-space 1)
  (insert "<<-")
  (just-one-space 1))

(defun efs/ess-rmarkdown ()
  "Compile R markdown (.Rmd). Should work for any output type."
  (interactive)
  ;; Check if attached R-session
  (condition-case nil
      (ess-get-process)
    (error
     (ess-switch-process)))
  (let* ((rmd-buf (current-buffer)))
    (save-excursion
      (let* ((sprocess (ess-get-process ess-current-process-name))
             (sbuffer (process-buffer sprocess))
             (buf-coding (symbol-name buffer-file-coding-system))
             (R-cmd
              (format "library(rmarkdown); rmarkdown::render(\"%s\", \"all\")"
                      buffer-file-name)))
        (message "Running rmarkdown on %s" buffer-file-name)
        (ess-execute R-cmd 'buffer nil nil)
        (switch-to-buffer rmd-buf)
        (ess-show-buffer (buffer-name sbuffer) nil)))))

(defun efs/ess-bookdown ()
  "Compile with bookdown (.Rmd). Should work for any output type."
  (interactive)
  ;; Check if attached R-session
  (condition-case nil
      (ess-get-process)
    (error
     (ess-switch-process)))
  (let* ((rmd-buf (current-buffer)))
    (save-excursion
      (let* ((sprocess (ess-get-process ess-current-process-name))
             (sbuffer (process-buffer sprocess))
             (buf-coding (symbol-name buffer-file-coding-system))
             (R-cmd
              (format "bookdown::render_book(\"%s\")"
                      buffer-file-name)))
        (message "Running bookdown on %s" buffer-file-name)
        (ess-execute R-cmd 'buffer nil nil)
        (switch-to-buffer rmd-buf)
        (ess-show-buffer (buffer-name sbuffer) nil)))))

(defun efs/ess-xaringan ()
  "Compile with xaringan moon_reader (.Rmd). Should work for any output type."
  (interactive)
  ;; Check if attached R-session
  (condition-case nil
      (ess-get-process)
    (error
     (ess-switch-process)))
  (let* ((rmd-buf (current-buffer)))
    (save-excursion
      (let* ((sprocess (ess-get-process ess-current-process-name))
             (sbuffer (process-buffer sprocess))
             (buf-coding (symbol-name buffer-file-coding-system))
             (R-cmd
              (format "rmarkdown::render(\"%s\", \"xaringan::moon_reader\")"
                      buffer-file-name)))
        (message "Running xaringan::moon_reader on %s" buffer-file-name)
        (ess-execute R-cmd 'buffer nil nil)
        (switch-to-buffer rmd-buf)
        (ess-show-buffer (buffer-name sbuffer) nil)))))

(defun efs/ess-rshiny ()
  "Compile R markdown (.Rmd). Should work for any output type."
  (interactive)
  ;; Check if attached R-session
  (condition-case nil
      (ess-get-process)
    (error
     (ess-switch-process)))
  (let* ((rmd-buf (current-buffer)))
    (save-excursion
      (let* ((sprocess (ess-get-process ess-current-process-name))
             (sbuffer (process-buffer sprocess))
             (buf-coding (symbol-name buffer-file-coding-system))
             (R-cmd
              (format "library(rmarkdown); rmarkdown::run(\"%s\")"
                      buffer-file-name)))
        (message "Running shiny on %s" buffer-file-name)
        (ess-execute R-cmd 'buffer nil nil)
        (switch-to-buffer rmd-buf)
        (ess-show-buffer (buffer-name sbuffer) nil)))))

(defun efs/ess-publish-rmd ()
  "Publish R Markdown (.Rmd) to remote server"
  (interactive)
  ;; Check if attached R-session
  (condition-case nil
      (ess-get-process)
    (error
     (ess-switch-process)))
  (let* ((rmd-buf (current-buffer)))
    (save-excursion
      ;; assignment
      (let* ((sprocess (ess-get-process ess-current-process-name))
             (sbuffer (process-buffer sprocess))
             (buf-coding (symbol-name buffer-file-coding-system))
             (R-cmd
              (format "workflow::wf_publish_rmd(\"%s\")"
                      buffer-file-name)))
        ;; execute
        (message "Publishing rmarkdown on %s" buffer-file-name)
        (ess-execute R-cmd 'buffer nil nil)
        (switch-to-buffer rmd-buf)
        (ess-show-buffer (buffer-name sbuffer) nil)))))

;; set up ess
(use-package ess
  ;; :defer t
  ;; :straight t
  :init
  (require 'ess-r-mode)
  ;;(require 'ess-view-data)
  ;; (require 'ess-site)
  ;; (require 'ess-rutils)
  ;; Auto set width and length options when initiate new Ess processes
  :config
  (add-hook 'ess-post-run-hook 'ess-execute-screen-options)
  (add-hook 'ess-mode-hook (lambda () (run-hooks 'prog-mode-hook)))
  (add-hook 'ess-mode-hook ;; truncate lines to make tables easier to view
            (lambda () (toggle-truncate-lines t)))
  (add-hook 'ess-mode-hook
            (lambda () (ess-set-style 'RRR 'quiet)
              (add-hook 'local-write-file-hooks
                        (lambda () (ess-nuke-trailing-whitespace)))))
  (add-hook 'inferior-ess-mode-hook 'ansi-color-for-comint-mode-on)
  (add-hook 'inferior-ess-mode-hook #'(lambda ()
                                        (setq-local comint-use-prompt-regexp nil)
                                        (setq-local inhibit-field-text-motion nil)))
  (add-hook 'ess-r-mode-hook
            (lambda()
              'eglot-ensure
              (make-local-variable 'company-backends)
              (delete-dups (push 'company-capf company-backends))
              (delete-dups (push 'company-files company-backends))))
  (add-to-list 'comint-output-filter-functions 'ansi-color-process-output)
  (show-paren-mode)
  ;;(setq ess-eval-empty t)               ; don't skip non-code line
  (setq comint-scroll-to-bottom-on-input 'this)
  (setq comint-move-point-for-output 'others)
  ;;(setq ess-ask-for-ess-directory nil)
  (setq ess-eval-visibly 'nowait)
  (setq ess-use-flymake nil)
  ;; (setq ess-r-flymake-linters '("infix_spaces_linter" . "commas_linter"))
  (setq ess-roxy-fold-examples nil)
  (setq ess-roxy-fontify-examples t)
  (setq ess-use-company 'script-only)
  (setq ess-company-arg-prefix-length 1)
  ;;(setq ess-blink-region nil)

  (setq ess-r-flymake-lintr-cache nil)
  (setq ess-history-directory "~/.R/")
  (setq inferior-R-args "--no-restore-history --no-save")
  (setq ess-offset-arguments 'prev-line)

  (setq ess-indent-with-fancy-comments nil)

  ;; fix assignment key
  (ess-toggle-underscore nil)
  (setq ess-insert-assign (car ess-assign-list))
  (setq ess-assign-list '(" = "))
  (bind-key "M--" 'ess-insert-assign)

  (setq ess-eldoc-show-on-symbol nil)
  ;; This may cause massive slow downs?
  (setq ess-eldoc-abbreviation-style nil)
  ;;(setq ess-use-eldoc nil)
  (setq comint-scroll-to-bottom-on-output t)
  :general
  (global-leader
   :major-modes
   '(ess-r-mode inferior-ess-r-mode t)
   :keymaps
   '(ess-r-mode-map inferior-ess-r-mode-map)
   "e" '(:ignore e :which-key "eval")
   "eb" '(ess-eval-buffer :which-key "buffer")
   "ed" '(eval-buffer-from-beg-to-here :which-key "buffer from beg")
   "ee" '(eval-buffer-from-here-to-end :which-key "buffer to end")
   "el" '(ess-eval-region-or-line-and-step :which-key "line or region")
   "ef" '(ess-eval-function-or-paragraph-and-step :which-key "function or paragraph")
   "er" '(polymode-eval-region-or-chunk :which-key "Rmd region or chunk")
   "eB" '(polymode-eval-buffer-from-beg-to-point :which-key "Rmd chunks from beg to point")
   "eE" '(polymode-eval-buffer-from-point-to-end :which-key "Rmd chunks from point to end")
   "r" '(:ignore r :which-key "Rmd")
   "rb" '(efs/ess-bookdown :which-key "bookdown-export")
   "rx" '(efs/ess-xaringan :which-key "xaringan-export")
   "re" '(efs/ess-rmarkdown :which-key "Rmd-export")
   "rs" '(efs/ess-rshiny :which-key "shiny-export")
   "rd" '(efs/ess-publish-rmd :which-key "publish Rmd")
   "rn" '(polymode-next-chunk :which-key "next chunk")
   "rp" '(polymode-previous-chunk :which-key "previous chunk")
   "rk" '(polymode-kill-chunk :which-key "kill chunk")
   "rl" '(markdown-insert-link :which-key "insert link")
   "ri" '(markdown-insert-image :which-key "insert image")
   "d" '(ess-doc-map :which-key "docs")
   ;;"c" '(ess-r-mode-map :which-key "ess r map") ; doesn't work - maybe command?
   "i" '(:ignore i :which-key "insert")
   "ii" '(efs/insert-r-in :which-key "%in%")
   "id" '(efs/insert_double_assign_operator :which-key "<<-")
   ";" '(ess-insert-assign :which-key "<-")
   "p" '(efs/insert-r-pipe :which-key "insert %>%")
   "v" '(ess-rdired :which-key "rdired")
   "w" '(ess-set-working-directory :which-key "set wd")))
;; :bind (:map ess-r-mode-map
;;             ("C-c C-w w" . ess-r-package-use-dir)
;;             ("C-c C-w C-w" . ess-r-package-use-dir)
;;             ("<C-M-return>" . ess-eval-region-or-function-or-paragraph-and-step)
;;             ("<C-S-return>" . ess-eval-buffer)
;;             ("C-M-;" . comment-line)
;;             ("C-S-<f10>" . inferior-ess-reload)
;;             ("<f5>" . ess-display-help-on-object)
;;             ("<C-return>" . ess-eval-region-or-function-or-paragraph))
;; :bind (:map inferior-ess-mode-map
;;             ("C-S-<f10>" . inferior-ess-reload)))

;; An example of window configuration:
(setq display-buffer-alist
      '(("*R Dired"
         (display-buffer-reuse-window display-buffer-at-bottom)
         (window-width . 0.5)
         (window-height . 0.25)
         (reusable-frames . nil))
        ("*R"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . right)
         (slot . -1)
         (window-width . 0.5)
         (reusable-frames . nil))
        ("*Help"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . right)
         (slot . 1)
         (window-width . 0.5)
         (reusable-frames . nil))))
;; syntax highlight
(setq ess-R-font-lock-keywords
      (quote
       ((ess-R-fl-keyword:modifiers . t)
        (ess-R-fl-keyword:fun-defs . t)
        (ess-R-fl-keyword:fun-defs2 . t)
        (ess-R-fl-keyword:keywords . t)
        (ess-R-fl-keyword:assign-ops)
        (ess-R-fl-keyword:constants . t)
        (ess-fl-keyword:fun-calls . t)
        (ess-fl-keyword:numbers . t)
        (ess-fl-keyword:operators)
        (ess-fl-keyword:delimiters)
        (ess-fl-keyword:=)
        (ess-fl-keyword::= . t)
        (ess-R-fl-keyword:F&T)
        (ess-R-fl-keyword:%op%))))

(setq inferior-ess-r-font-lock-keywords
      (quote
       ((ess-S-fl-keyword:prompt . t)
        (ess-R-fl-keyword:messages . t)
        (ess-R-fl-keyword:modifiers . t)
        (ess-R-fl-keyword:fun-defs . t)
        (ess-R-fl-keyword:fun-defs2 . t)
        (ess-R-fl-keyword:keywords . t)
        (ess-R-fl-keyword:assign-ops)
        (ess-R-fl-keyword:constants . t)
        (ess-fl-keyword:matrix-labels)
        (ess-fl-keyword:fun-calls)
        (ess-fl-keyword:numbers)
        (ess-fl-keyword:operators)
        (ess-fl-keyword:delimiters)
        (ess-fl-keyword:=)
        (ess-fl-keyword::= . t)
        (ess-R-fl-keyword:F&T))))

(use-package polymode)
(use-package poly-R)
(use-package poly-markdown
  :config
  (add-to-list 'auto-mode-alist '("\\.rmd" . poly-markdown+R-mode))
  )
(with-eval-after-load "markdown"
  (use-package poly-markdown))
;; (with-eval-after-load "org"
;;   (use-package poly-org))

(setq ispell-dictionary "en-custom")

(setq ispell-personal-dictionary (expand-file-name ".ispell_personal" doom-private-dir))
