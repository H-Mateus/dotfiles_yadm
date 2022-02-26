;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "Mateus"
      user-mail-address "Bernardo-HarringtonG@cardiff.ac.uk")

(setq doom-font (font-spec :family "Fira Code" :size 18)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 19)
      doom-big-font (font-spec :family "Fira Code" :size 24))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'modus-vivendi) ; theme not loading for some reason
;; backup theme
(setq doom-theme 'doom-acario-dark)

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

(after! doom-modeline
  (setq doom-modeline-enable-word-count t))

(map! :leader
      :desc "Swiper" "b f" #'swiper
      :desc "evil-comment" "b /" #'evilnc-comment-or-uncomment-lines)

;; another example:
;; (map! :leader
;;       (:prefix-map ("a" . "applications")
;;        (:prefix ("j" . "journal")
;;         :desc "New journal entry" "j" #'org-journal-new-entry
;;         :desc "Search journal entry" "s" #'org-journal-search)))

(map! :localleader
      :map markdown-mode-map
      :prefix ("i" . "Insert")
      :desc "Blockquote"    "q" 'markdown-insert-blockquote
      :desc "Bold"          "b" 'markdown-insert-bold
      :desc "Code"          "c" 'markdown-insert-code
      :desc "Emphasis"      "e" 'markdown-insert-italic
      :desc "Footnote"      "f" 'markdown-insert-footnote
      :desc "Code Block"    "s" 'markdown-insert-gfm-code-block
      :desc "Image"         "i" 'markdown-insert-image
      :desc "Link"          "l" 'markdown-insert-link
      :desc "List Item"     "n" 'markdown-insert-list-item
      :desc "Pre"           "p" 'markdown-insert-pre
      (:prefix ("h" . "Headings")
       :desc "One"   "1" 'markdown-insert-atx-1
       :desc "Two"   "2" 'markdown-insert-atx-2
       :desc "Three" "3" 'markdown-insert-atx-3
       :desc "Four"  "4" 'markdown-insert-atx-4
       :desc "Five"  "5" 'markdown-insert-atx-5
       :desc "Six"   "6" 'markdown-insert-atx-6))

(map! :localleader
      :map (org-mode-map pdf-view-mode-map)
      (:prefix ("o" . "Org")
       (:prefix ("n" . "Noter")
        :desc "Noter" "n" 'org-noter
        )))

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
      scroll-margin 4)                            ; It's nice to maintain a little margin

(display-time-mode 1)                             ; Enable time in the mode-line

(unless (equal "Battery status not available"
               (battery))                         ; On laptops...
  (display-battery-mode 1))                       ; it's nice to know how much power you have

(global-subword-mode 1)                           ; Iterate through CamelCase words

(setq which-key-idle-delay 0.5) ;; I need the help, I really do

(after! evil
  (setq evil-ex-substitute-global t     ; I like my s/../.. to by global by default
        evil-move-cursor-back nil       ; Don't move the block cursor when toggling insert mode
        evil-kill-on-visual-paste nil)) ; Don't put overwritten text in the kill ring

(setq evil-vsplit-window-right t
      evil-split-window-below t)

(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))

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

(after! org
  (setq org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-item-bullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        ))

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
          ;; ("r" "reference" plain "%?"
          ;;  :if-new
          ;;  (file+head "reference/${slug}.org" "#+title: ${title}\n")
          ;;  :immediate-finish t
          ;;  :unnarrowed t)
          ;; below is taken from org-roam-bibtex manual <2022-02-26 Sat>
          ;; ("r" "bibliography reference" plain
          ;;  (file "~/Documents/template.org")
          ;;  :target
          ;;  (file+head "references/${citekey}.org" "#+title: ${title}\n"))
          ("s" "standard" plain "%?"
           :if-new
           (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                      "#+title: ${title}\n#+filetags: \n\n ")
           :unnarrowed t)
          ("d" "definition" plain
           "%?"
           :if-new
           (file+head "${slug}.org" "#+title: ${title}\n#+filetags: definition \n\n* Definition\n\n\n* Examples\n")
           :unnarrowed t)
          ("r" "reference" plain "%?"
           :if-new
           (file+head "${citekey}.org"
                      "#+title: ${slug}: ${title}\n
\n#+filetags: reference ${keywords} \n
\n* ${title}\n\n
\n* Summary
\n\n\n* Rough note space\n")
           :unnarrowed t)
          ("p" "person" plain "%?"
           :if-new
           (file+head "${slug}.org" "%^{relation|some guy|family|friend|colleague}p %^{birthday}p %^{address}p
#+title:${slug}\n#+filetags: :person: \n"
                      :unnarrowed t))
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

(use-package! org-ref
  ;;:after org-roam
  :config
  (setq
   org-ref-completion-library 'org-ref-ivy-cite
   org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
   bibtex-completion-bibliography mh/default-bibliography
   bibtex-completion-notes "~/Documents/org/references/notes/bibnotes.org"
   org-ref-note-title-format "* %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
   org-ref-notes-directory "~/Documents/org/references/notes/"
   org-ref-notes-function 'orb-edit-notes
   ))

(after! org-ref
  (setq
   bibtex-completion-notes-path "~/Documents/org/references/notes/"
   bibtex-completion-bibliography mh/default-bibliography
   bibtex-completion-pdf-field "file"
   bibtex-completion-notes-template-multiple-files
   (concat
    "#+TITLE: ${title}\n"
    "#+ROAM_KEY: cite:${=key=}\n"
    "* TODO Notes\n"
    ":PROPERTIES:\n"
    ":Custom_ID: ${=key=}\n"
    ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
    ":AUTHOR: ${author-abbrev}\n"
    ":JOURNAL: ${journaltitle}\n"
    ":DATE: ${date}\n"
    ":YEAR: ${year}\n"
    ":DOI: ${doi}\n"
    ":URL: ${url}\n"
    ":END:\n\n"
    )))

;; (after! bibtex-completion
;;   (setq! bibtex-completion-notes-path org-roam-directory
;;          bibtex-completion-bibliography mh/default-bibliography
;;          org-cite-global-bibliography mh/default-bibliography
;;          bibtex-completion-pdf-field "file"))

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

(use-package! org-roam-bibtex
  :after org-roam
  :hook (org-mode . org-roam-bibtex-mode)
  :config
  (require 'org-ref)
  (setq orb-preformat-keywords
        '("citekey" "title" "url" "file" "author-or-editor" "keywords" "pdf" "doi" "author" "tags" "year" "author-bbrev")))

(use-package! org-noter
  :after (:any org pdf-view)
  :config
  (setq
   ;; The WM can handle splits
   org-noter-notes-window-location 'other-frame
   ;; Please stop opening frames
   ;;org-noter-always-create-frame nil
   ;; I want to see the whole file
   org-noter-hide-other nil
   ;; Everything is relative to the rclone mega
   org-noter-notes-search-path "~/Documents/org/references/notes"))

(use-package! org-pdftools
  :hook (org-load . org-pdftools-setup-link))
(use-package! org-noter-pdftools
  :after org-noter
  :config
  (with-eval-after-load 'pdf-annot
    (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))

(after! pdf-view
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-width)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t
        pdf-view-resize-factor 1.1)
  ;; faster motion
  (map!
   :map pdf-view-mode-map
   :n "g g"          #'pdf-view-first-page
   :n "G"            #'pdf-view-last-page
   :n "N"            #'pdf-view-next-page-command
   :n "E"            #'pdf-view-previous-page-command
   :n "e"            #'evil-collection-pdf-view-previous-line-or-previous-page
   :n "n"            #'evil-collection-pdf-view-next-line-or-next-page
   :localleader
   (:prefix "o"
    (:prefix "n"
     :desc "Insert" "i" 'org-noter-insert-note))))

(map! :leader
      (:prefix-map ("C" . "citations")
       :desc "Citar refresh" "r" #'citar-refresh
       :desc "Insert citation" "i" #'citar-insert-citation
       :desc "Open notes" "n" #'citar-open-notes
       :desc "Export bib" "e" #'citar-export-local-bib-file
       :desc "Select csl style" "s" #'citar-citeproc-select-csl-style
       (:prefix ("j" . "journal")
        :desc "New journal entry" "j" #'org-journal-new-entry
        :desc "Search journal entry" "s" #'org-journal-search)))

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

(map! :leader
      (:prefix ("r" . "registers")
       :desc "Copy to register" "c" #'copy-to-register
       :desc "Frameset to register" "f" #'frameset-to-register
       :desc "Insert contents of register" "i" #'insert-register
       :desc "Jump to register" "j" #'jump-to-register
       :desc "List registers" "l" #'list-registers
       :desc "Number to register" "n" #'number-to-register
       :desc "Interactively choose a register" "r" #'counsel-register
       :desc "View a register" "v" #'view-register
       :desc "Window configuration to register" "w" #'window-configuration-to-register
       :desc "Increment register" "+" #'increment-register
       :desc "Point to register" "SPC" #'point-to-register))

(setq projectile-project-search-path '("~/git_work/"))

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

(after! ess
  (add-hook! 'prog-mode-hook #'rainbow-delimiters-mode)

  ;; combines https://github.com/fernandomayer/spacemacs/blob/master/private/ess/packages.el and
  ;; https://github.com/MilesMcBain/spacemacs_cfg/blob/master/private/ess/packages.el.

  ;; If I use LSP it is better to let LSP handle lintr. See example in
  ;; https://github.com/hlissner/doom-emacs/issues/2606.
  (setq! ess-use-flymake nil)
  (setq! lsp-ui-doc-enable nil
         lsp-ui-doc-delay 1.5)

  ;; Code indentation copied from my old config.
  ;; Follow Hadley Wickham's R style guide
  (setq
   ess-style 'RStudio
   ess-offset-continued 2
   ess-expression-offset 0)

  (setq comint-move-point-for-output t)

  ;; From https://emacs.readthedocs.io/en/latest/ess__emacs_speaks_statistics.html
  ;; TODO: find out a way to make settings generic so that I can also set ess-inf-R-font-lock-keywords
  (setq ess-R-font-lock-keywords
        '((ess-R-fl-keyword:modifiers  . t)
          (ess-R-fl-keyword:fun-defs   . t)
          (ess-R-fl-keyword:keywords   . t)
          (ess-R-fl-keyword:assign-ops . t)
          (ess-R-fl-keyword:constants  . t)
          (ess-fl-keyword:fun-calls    . t)
          (ess-fl-keyword:numbers      . t)
          (ess-fl-keyword:operators    . t)
          (ess-fl-keyword:delimiters) ; don't because of rainbow delimiters
          (ess-fl-keyword:=            . t)
          (ess-R-fl-keyword:F&T        . t)
          (ess-R-fl-keyword:%op%       . t)))
  )

  ;; ESS buffers should not be cleaned up automatically
  ;; (add-hook 'inferior-ess-mode-hook #'doom-mark-buffer-as-real-h)

  ;; Open ESS R window to the left iso bottom.
  ;; (set-popup-rule! "^\\*R.*\\*$" :side 'left :size 0.38 :select nil :ttl nil :quit nil :modeline t))

;; Activate polymode when loading Rmarkdown documents. Also see
;; https://github.com/MilesMcBain/spacemacs_cfg/blob/master/private/polymode/packages.el
;; for somewhat outdated hints about a personal Rmd-mode
(use-package! polymode
  :commands (R))

;; (after! markdown-mode
;;   ;; Disable trailing whitespace stripping for Markdown mode
;;   (add-hook 'markdown-mode-hook #'doom-disable-delete-trailing-whitespace-h)
;;   ;; Doom adds extra line spacing in markdown documents
;;   (add-hook! 'markdown-mode-hook :append (setq line-spacing nil)))

;; From Tecosaur's configuration
(add-hook! (gfm-mode markdown-mode) #'mixed-pitch-mode)
;; (add-hook! (gfm-mode markdown-mode) #'visual-line-mode #'turn-off-auto-fill)
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
;; Material on completing/completion mostly from
;; https://github.com/tecosaur/emacs-config/blob/master/config.org
;;
;; company-show-numbers works with Alt-x.
;; (after! company
;;   (setq company-show-numbers t))
(set-company-backend! '(text-mode
                        markdown-mode
                        gfm-mode)
  '(:seperate company-ispell
    company-files
    company-yasnippet))
;; by default the following also has R-library in there, so this is not needed.
;; (set-company-backend! 'ess-r-mode '(company-R-args company-R-objects company-dabbrev-code :separate))
(setq-default history-length 1000)
(setq-default prescient-history-length 1000)

;; (after! ess
;;  (map! :localleader
;;  ;; (:map ess-r-mode-map
;;   (:prefix ("e" . "Rmd export")
;;         :desc "next chunk" "n" #'polymode-next-chunk)))

(map! :leader
      (:prefix-map ("e" . "Extras")
       (:prefix ("r" . "Rmd")
        :desc "next chunk" "n" #'polymode-next-chunk
        :desc "previous chunk" "p" #'polymode-previous-chunk
        :desc "kill chunk" "k" #'polymode-kill-chunk
       (:prefix ("e" . "eval")
        :desc "eval region or chunk" "e" #'polymode-eval-region-or-chunk
        :desc "eval buffer to point" "b" #'polymode-eval-buffer-from-beg-to-point
        :desc "eval point to end" "E" #'polymode-eval-buffer-from-point-to-end)
       (:prefix ("E" . "export")
        :desc "Export Rmd" "e" #'efs/ess-rmarkdown
        :desc "xaringan-export" "x" #'efs/ess-xaringan
        :desc "rshiny-export" "s" #'efs/ess-rshiny
        :desc "publish-rmd" "p" #'efs/ess-publish
        :desc "bookdown-export" "b" #'efs/ess-bookdown))))

;; "rl" '(markdown-insert-link :which-key "insert link")
;; "ri" '(markdown-insert-image :which-key "insert image")

;; Load
(use-package! poly-R
:config
(map! (:localleader
      :map polymode-mode-map
      :desc "Export"   "e" 'polymode-export
      :desc "Errors" "$" 'polymode-show-process-buffer
      :desc "Weave" "w" 'polymode-weave
      ;; (:prefix ("n" . "Navigation")
      ;;   :desc "Next" "n" . 'polymode-next-chunk
      ;;   :desc "Previous" "N" . 'polymode-previous-chunk)
      ;; (:prefix ("c" . "Chunks")
      ;;   :desc "Narrow" "n" . 'polymode-toggle-chunk-narrowing
      ;;   :desc "Kill" "k" . 'polymode-kill-chunk
      ;;   :desc "Mark-Extend" "m" . 'polymode-mark-or-extend-chunk)
      )))

(setq ispell-dictionary "en-custom")

(setq ispell-personal-dictionary (expand-file-name ".ispell_personal" doom-private-dir))

(setq writegood-mode nil)
