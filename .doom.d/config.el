;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Gabriel Mateus Bernardo Harrington"
      user-mail-address "g.m.bernardo.harrington@keele.ac.uk")

(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 tab-width 4                                                         ; Set width for tabs
 uniquify-buffer-name-style 'forward      ; Uniquify buffer names
 window-combination-resize t                    ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                                           ; Stretch cursor to the glyph width

(setq undo-limit 80000000                          ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                             ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                                    ; Nobody likes to loose work, I certainly don't
      inhibit-compacting-font-caches t      ; When there are lots of glyphs, keep them in memory
      truncate-string-ellipsis "…")               ; Unicode ellispis are nicer than "...", and also save /precious/ space

(delete-selection-mode 1)                             ; Replace selection when inserting text
(display-time-mode 1)                                   ; Enable time in the mode-line
(global-subword-mode 1)                           ; Iterate through CamelCase words
(setq line-spacing 0.3)                                   ; seems like a nice line spacing balance.

(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))                           ; On laptops it's nice to know how much power you have

(if (eq initial-window-system 'x)                 ; if started by emacs command or desktop file
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))

(setq evil-vsplit-window-right t
      evil-split-window-below t)
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer))
(setq +ivy-buffer-preview t)

(defun doom-modeline-conditional-buffer-encoding ()
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))
(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

(map! :map evil-window-map
      "SPC" #'rotate-layout
      "<left>"     #'evil-window-left
       "<down>"     #'evil-window-down
       "<up>"       #'evil-window-up
       "<right>"    #'evil-window-right
       ;; Swapping windows
       "C-<left>"       #'+evil/window-move-left
       "C-<down>"       #'+evil/window-move-down
       "C-<up>"         #'+evil/window-move-up
       "C-<right>"      #'+evil/window-move-right)

(setq frame-title-format
    '(""
      (:eval
       (if (s-contains-p org-roam-directory (or buffer-file-name ""))
           (replace-regexp-in-string ".*/[0-9]*-?" "🢔 " buffer-file-name)
         "%b"))
      (:eval
       (let ((project-name (projectile-project-name)))
         (unless (string= "-" project-name)
           (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 18)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 26)
      doom-variable-pitch-font (font-spec :family "Overpass Nerd Font" :size 18))

;;light themes
                                        ;(setq doom-theme 'doom-gruvbox-light)
                                        ;(setq doom-theme 'zaiste)
                                        ;(setq doom-theme 'doom-flatwhite)
;;dark themes
(setq doom-theme 'doom-acario-dark)

(setq display-line-numbers-type t)

(setq org-directory "~/Documents/org/"
      org-log-done 'time                          ; having the time a item is done sounds convininet
      org-list-allow-alphabetical t               ; have a. A. a) A) list bullets
                                        ;org-export-in-background t                  ; run export processes in external emacs process
      org-catch-invisible-edits 'smart            ; try not to accidently do weird stuff in invisible regions
      org-re-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")

(use-package org
  :config
  (setq org-babel-default-header-args
        (cons '(:exports . "both")
              (assq-delete-all :exports org-babel-default-header-args))
        org-babel-default-header-args
        (cons '(:results . "output verbatim replace")
              (assq-delete-all :results org-babel-default-header-args))
        )
  )

(use-package! org-ref
  :after org
  :init
                                        ; code to run before loading org-ref
  :config
                                        ; code to run after loading org-ref
  )
(setq org-ref-notes-directory "~/Documents/org"
                                        ; org-ref-bibliography-notes "~/Documents/Org/references/articles.org" ;; not needed anymore. Notes now taken in org-roaM
      org-ref-default-bibliography '("~/Documents/masterLib.bib")
      org-ref-pdf-directory "~/Zotero/")

;; (after! org
;;   (add-to-list 'org-capture-templates
;;                '(("a"               ; key
;;                   "Article"         ; name
;;                   entry             ; type
;;                   (file+headline "org" "Article")  ; target
;;                   "\* %^{Title} %(org-set-tags)  :article: \n:PROPERTIES:\n:Created: %U\n:Linked: %a\n:END:\n%i\nBrief description:\n%?"  ; template

;;                   :prepend t        ; properties
;;                   :empty-lines 1    ; properties
;;                   :created t        ; properties
;;                   ))) )

(use-package! helm-bibtex
  :after org
  :init
  ; blah blah
  :config
  ;blah blah
  )

(setq bibtex-format-citation-functions
      '((org-mode . (lambda (x) (insert (concat
                                         "\\cite{"
                                         (mapconcat 'identity x ",")
                                         "}")) ""))))
(setq
      bibtex-completion-pdf-field "file"
      bibtex-completion-bibliography
      '("~/Documents/masterLib.bib")
      bibtex-completion-library-path '("~/Zotero/")
     ; bibtex-completion-notes-path "~/Documents/Org/references/articles.org"  ;; not needed anymore as I take notes in org-roam
      )

(use-package! zotxt
  :after org)
;(add-to-list 'load-path (expand-file-name "ox-pandoc" starter-kit-dir))

(use-package! ox-pandoc
  :after org)
;; default options for all output formats
(setq org-pandoc-options '((standalone . _)))
;; cancel above settings only for 'docx' format
(setq org-pandoc-options-for-docx '((standalone . nil)))
;; special settings for beamer-pdf and latex-pdf exporters
(setq org-pandoc-options-for-beamer-pdf '((pdf-engine . "xelatex")))
(setq org-pandoc-options-for-latex-pdf '((pdf-engine . "pdflatex")))
;; special extensions for markdown_github output
(setq org-pandoc-format-extensions '(markdown_github+pipe_tables+raw_html))

(use-package! org-roam-bibtex
  :load-path "~/Documents/masterLib.bib" ;Modify with your own path
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :bind (:map org-mode-map
         (("C-c n a" . orb-note-actions))))
(setq orb-templates
      '(("r" "ref" plain (function org-roam-capture--get-point) ""
         :file-name "${citekey}"
         :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}\n" ; <--
         :unnarrowed t)))
(setq orb-preformat-keywords   '(("citekey" . "=key=") "title" "url" "file" "author-or-editor" "keywords"))

(setq orb-templates
      '(("n" "ref+noter" plain (function org-roam-capture--get-point)
         ""
         :file-name "${slug}"
         :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}\n#+ROAM_TAGS:

- tags ::
- keywords :: ${keywords}
\* ${title}
:PROPERTIES:
:Custom_ID: ${citekey}
:URL: ${url}
:AUTHOR: ${author-or-editor}
:NOTER_DOCUMENT: %(orb-process-file-field \"${citekey}\")
:NOTER_PAGE:
:END:")))

; org-roam settings
(setq org-roam-directory "~/Documents/org-roam")
(after! org-roam
        (map! :leader
            :prefix "n"
            :desc "org-roam" "l" #'org-roam
            :desc "org-roam-insert" "i" #'org-roam-insert
            :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
            :desc "org-roam-find-file" "f" #'org-roam-find-file
            :desc "org-roam-show-graph" "g" #'org-roam-show-graph
            :desc "org-roam-insert" "i" #'org-roam-insert
            :desc "org-roam-capture" "c" #'org-roam-capture))
(after! org-roam
      (setq org-roam-ref-capture-templates
            '(("r" "ref" plain (function org-roam-capture--get-point)
               "%?"
               :file-name "websites/${slug}"
               :head "#+TITLE: ${title}
    #+ROAM_KEY: ${ref}
    - source :: ${ref}"
               :unnarrowed t))))  ; capture template to grab websites. Requires org-roam protocol.

;; org-journal the DOOM way
(use-package org-journal
  :init
  (setq org-journal-dir "~/Documents/org/Daily/"
        org-journal-date-prefix "#+TITLE: "
        org-journal-file-format "%Y-%m-%d.org"
        org-journal-date-format "%A, %d %B %Y")
  :config
  (setq org-journal-find-file #'find-file-other-window )
  (map! :map org-journal-mode-map
        "C-c n s" #'evil-save-modified-and-close )
  )

(setq org-journal-enable-agenda-integration t)

(use-package deft
      :after org
      :bind
      ("C-c n d" . deft)
      :custom
      (deft-recursive t)
      (deft-use-filter-string-for-filename t)
      (deft-default-extension "org")
      (deft-directory "~/Documents/org-roam"))

(use-package! org-roam-server
  :after org-roam
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8078
        org-roam-server-export-inline-images t
        org-roam-server-authenticate nil
        org-roam-server-network-poll t
        org-roam-server-label-truncate t
        org-roam-server-label-truncate-length 60
        org-roam-server-label-wrap-length 20)
  (defun org-roam-server-open ()
    "Ensure the server is active, then open the roam graph."
    (interactive)
    (org-roam-server-mode 1)
    (browse-url-xdg-open (format "http://localhost:%d" org-roam-server-port))))
(after! org-roam
  (org-roam-server-mode))
;; (use-package org-roam-server
;;   :ensure t
;;   :config
;;   (setq org-roam-server-host "127.0.0.1"
;;         org-roam-server-port 8078
;;         org-roam-server-authenticate nil
;;         org-roam-server-export-inline-images t
;;         org-roam-server-serve-files nil
;;         org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
;;         org-roam-server-network-poll t
;;         org-roam-server-network-arrows nil
;;         org-roam-server-network-label-truncate t
;;         org-roam-server-network-label-truncate-length 60
;;         org-roam-server-network-label-wrap-length 20))

(unless (server-running-p)
  (org-roam-server-mode))

(use-package! org-download
  :after org
  :bind
  (:map org-mode-map
        (("s-Y" . org-download-screenshot)
         ("s-y" . org-download-yank))))

;(after! centaur-tabs
 ; (centaur-tabs-mode -1)
  ;(setq centaur-tabs-height 36
   ;     centaur-tabs-set-icons t
    ;    centaur-tabs-modified-marker "o"
     ;   centaur-tabs-close-button "×"
      ;  centaur-tabs-set-bar 'above)
       ; centaur-tabs-gray-out-icons 'buffer
  ;(centaur-tabs-change-fonts "P22 Underground Book" 160))
;; (setq x-underline-at-descent-line t)

(use-package! org-fancy-priorities
; :ensure t
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
   (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))

(use-package! org-super-agenda
  :commands (org-super-agenda-mode))
(after! org-agenda
  (org-super-agenda-mode))

(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-tags-column 100 ;; from testing this seems to be a good value
      org-agenda-compact-blocks t)
;;(setq org-agenda-files (quote "~/Documents/org"))
(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                          :time-grid t
                          :date today
                          :todo "TODAY"
                          :scheduled today
                          :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next to do"
                           :todo "NEXT"
                           :order 1)
                          (:name "Important"
                           :tag "Important"
                           :priority "A"
                           :order 1)
                          (:name "Due Today"
                           :deadline today
                           :order 2)
                          (:name "Due Soon"
                           :deadline future
                           :order 8)
                          (:name "Overdue"
                           :deadline past
                           :face error
                           :order 7)
                          (:name "Work"
                           :tag "Work"
                           :order 3)
                          (:name "Dissertation"
                           :tag "Dissertation"
                           :order 7)
                          (:name "Emacs"
                           :tag "Emacs"
                           :order 13)
                          (:name "Projects"
                           :tag "Project"
                           :order 14)
                          (:name "Essay 1"
                           :tag "Essay1"
                           :order 2)
                          (:name "Reading List"
                           :tag "Read"
                           :order 8)
                          (:name "Work In Progress"
                           :tag "WIP"
                           :order 5)
                          (:name "Blog"
                           :tag "Blog"
                           :order 12)
                          (:name "Essay 2"
                           :tag "Essay2"
                           :order 3)
                          (:name "Trivial"
                           :priority<= "E"
                           :tag ("Trivial" "Unimportant")
                           :todo ("SOMEDAY" )
                           :order 90)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-journal-date-format "%A, %d %B %Y" t)
 '(org-journal-date-prefix "#+TITLE: " t)
 '(org-journal-dir "~/Documents/org/Daily/" t)
 '(org-journal-file-format "%Y-%m-%d.org" t)
 '(package-selected-packages (quote (org-fancy-priorities))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; adding custom key-bindings for most used functions
(map! :leader "f a"#'helm-bibtex)  ; "find article" : opens up helm bibtex for search.
(map! :leader "o n"#'org-noter)    ; "org noter"  : opens up org noter in a headline
(map! :leader "r c i"#'org-clock-in); "routine clock in" : clock in to a habit.
(map! :leader "c b"#'beacon-blink) ; "cursor blink" : makes the beacon-blink
(map! :leader "n r t"#'org-roam-tag-add)
(map! :leader "n r s"#'org-roam-db-build-cache)
(map! :leader "o a f"#'org-agenda-file-to-front)

(setq-default evil-escape-key-sequence "ii")
(setq-default evil-escape-delay 0.2)

(use-package! org
  :config
  (setq
  ; org-bullets-bullet-list '("⁖")
   org-todo-keyword-faces
   '(("TODO" :foreground "#7c7c75" :weight normal :underline t)
     ("WAITING" :foreground "#9f7efe" :weight normal :underline t)
     ("INPROGRESS" :foreground "#0098dd" :weight normal :underline t)
     ("DONE" :foreground "#50a14f" :weight normal :underline t)
     ("CANCELLED" :foreground "#ff6480" :weight normal :underline t))
   org-priority-faces '((65 :foreground "#e45649")
                        (66 :foreground "#da8548")
                        (67 :foreground "#0098dd"))
   ))

(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2
        company-box-doc-delay 2.0)
  (setq company-show-numbers t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort)) ;; make aborting less annoying.

(setq-default history-length 1000) ; remembering history from precedent
(setq-default prescient-history-length 1000)

(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)

(add-hook 'Info-mode-hook #'mixed-pitch-mode)

;; (defun org-hugo-new-subtree-post-capture-template ()
;;   "Returns `org-capture' template string for new Hugo post.
;; See `org-capture-templates' for more information."
;;   (let* (;; http://www.holgerschurig.de/en/emacs-blog-from-org-to-hugo/
;;          (date (format-time-string (org-time-stamp-format  :inactive) (org-current-time)))
;;          (title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
;;          (fname (org-hugo-slug title)))
;;     (mapconcat #'identity
;;                `(
;;                  ,(concat "* TODO " title)
;;                  ":PROPERTIES:"
;;                  ,(concat ":EXPORT_FILE_NAME: " fname)
;;                  ,(concat ":EXPORT_DATE: " date) ;Enter current date and time
;;                  ,(concat ":EXPORT_HUGO_CUSTOM_FRONT_MATTER: "  ":tags something :subtitle booyea :featured false :categories abc :highlight true ")
;;                  ":END:"
;;                  "%?\n")          ;Place the cursor here
;;                "\n")))
;; (defvar hugo-org-path "/home/cantos/Dropbox/blog/sunny-website/org-content/"
;;   "define the place where we put our org files for hugo")
;;(defvar org-capture-blog (concat hugo-org-path "blog.org"))

;; (setq org-capture-templates
;;       '(
;;         ("h" "Hugo Post"
;;          entry
;;          (file+olp "/home/cantos/Dropbox/blog/sunny-website/org-content/blog.org" "Posts")
;;          (function  org-hugo-new-subtree-post-capture-template)
;;          )
;;         ("t" "Personal todo"
;;          entry
;;          (file+headline "~/Documents/org/todo.org" "Inbox")
;;          "* TODO %?\n  %i\n  %a"
;;          )
;;         ("n" "Personal note"
;;          entry
;;          (file+headline "~/Documents/org/todo.org" "Inbox")
;;          "* %?\n  %i\n  %a"
;;          )
;;         ))

;; define variables for capture

(use-package! org-chef
  :commands (org-chef-insert-recipe org-chef-get-recipe-from-url))

(use-package! doct
  :commands (doct))

(setq org-capture-templates
      (doct '(
              ("Personal todo" :keys "t"
               :icon ("checklist" :set "octicon" :color "green")
               :file +org-capture-todo-file
               :prepend t
               :headline "Inbox"
               :type entry
               :template ("* TODO %?"
                          "%i %a")
               )
              ("Personal note" :keys "n"
               :icon ("sticky-note-o" :set "faicon" :color "green")
               :file +org-capture-todo-file
               :prepend t
               :headline "Inbox"
               :type entry
               :template ("* %?"
                          "%i %a")
               )
              ("University" :keys "u"
               :icon ("graduation-cap" :set "faicon" :color "purple")
               :file +org-capture-todo-file
               :headline "University"
               :unit-prompt ,(format "%%^{Unit|%s}" (string-join +org-capture-uni-units "|"))
               :prepend t
               :type entry
               :children (("Test" :keys "t"
                           :icon ("timer" :set "material" :color "red")
                           :template ("* TODO [#C] %{unit-prompt} %? :uni:tests:"
                                      "SCHEDULED: %^{Test date:}T"
                                      "%i %a"))
                          ("Assignment" :keys "a"
                           :icon ("library_books" :set "material" :color "orange")
                           :template ("* TODO [#B] %{unit-prompt} %? :uni:assignments:"
                                      "DEADLINE: %^{Due date:}T"
                                      "%i %a"))
                          ("Lecture" :keys "l"
                           :icon ("keynote" :set "fileicon" :color "orange")
                           :template ("* TODO [#C] %{unit-prompt} %? :uni:lecture:"
                                      "%i %a"))
                          ("Miscellaneous task" :keys "u"
                           :icon ("list" :set "faicon" :color "yellow")
                           :template ("* TODO [#D] %{unit-prompt} %? :uni:"
                                      "%i %a"))))
              ("Email" :keys "e"
               :icon ("envelope" :set "faicon" :color "blue")
               :file +org-capture-todo-file
               :prepend t
               :headline "Inbox"
               :type entry
               :template ("* TODO %^{type|reply to|contact} %\\3 %? :email:"
                          "Send an email %^{urgancy|soon|ASAP|anon|at some point|eventually} to %^{recipiant}"
                          "about %^{topic}"
                          "%U %i %a"))
              ("Interesting" :keys "i"
               :icon ("eye" :set "faicon" :color "lcyan")
               :file +org-capture-todo-file
               :prepend t
               :headline "Interesting"
               :type entry
               :template ("* [ ] %{desc}%? :%{i-type}:"
                          "%i %a")
               :children (("Webpage" :keys "w"
                           :icon ("globe" :set "faicon" :color "green")
                           :desc "%(org-cliplink-capture) "
                           :i-type "read:web"
                           )
                          ("Article" :keys "a"
                           :icon ("file-text" :set "octicon" :color "yellow")
                           :desc ""
                           :i-type "read:reaserch"
                           )
                          ("\tRecipie" :keys "r"
                           :icon ("spoon" :set "faicon" :color "dorange")
                           :file "~/Documents/org/recipes.org"
                           :headline "Unsorted"
                           :template "%(org-chef-get-recipe-from-url)"
                           )
                          ("Information" :keys "i"
                           :icon ("info-circle" :set "faicon" :color "blue")
                           :desc ""
                           :i-type "read:info"
                           )
                          ("Idea" :keys "I"
                           :icon ("bubble_chart" :set "material" :color "silver")
                           :desc ""
                           :i-type "idea"
                           )))
              ("Tasks" :keys "k"
               :icon ("inbox" :set "octicon" :color "yellow")
               :file +org-capture-todo-file
               :prepend t
               :headline "Tasks"
               :type entry
               :template ("* TODO %? %^G%{extra}"
                          "%i %a")
               :children (("General Task" :keys "k"
                           :icon ("inbox" :set "octicon" :color "yellow")
                           :extra ""
                           )
                          ("Task with deadline" :keys "d"
                           :icon ("timer" :set "material" :color "orange" :v-adjust -0.1)
                           :extra "\nDEADLINE: %^{Deadline:}t"
                           )
                          ("Scheduled Task" :keys "s"
                           :icon ("calendar" :set "octicon" :color "orange")
                           :extra "\nSCHEDULED: %^{Start time:}t"
                           )
                          ))
              ("Project" :keys "p"
               :icon ("repo" :set "octicon" :color "silver")
               :prepend t
               :type entry
               :headline "Inbox"
               :template ("* %{time-or-todo} %?"
                          "%i"
                          "%a")
               :file ""
               :custom (:time-or-todo "")
               :children (("Project-local todo" :keys "t"
                           :icon ("checklist" :set "octicon" :color "green")
                           :time-or-todo "TODO"
                           :file +org-capture-project-todo-file)
                          ("Project-local note" :keys "n"
                           :icon ("sticky-note" :set "faicon" :color "yellow")
                           :time-or-todo "%U"
                           :file +org-capture-project-notes-file)
                          ("Project-local changelog" :keys "c"
                           :icon ("list" :set "faicon" :color "blue")
                           :time-or-todo "%U"
                           :heading "Unreleased"
                           :file +org-capture-project-changelog-file))
               )
              ("\tCentralised project templates"
               :keys "o"
               :type entry
               :prepend t
               :template ("* %{time-or-todo} %?"
                          "%i"
                          "%a")
               :children (("Project todo"
                           :keys "t"
                           :prepend nil
                           :time-or-todo "TODO"
                           :heading "Tasks"
                           :file +org-capture-central-project-todo-file)
                          ("Project note"
                           :keys "n"
                           :time-or-todo "%U"
                           :heading "Notes"
                           :file +org-capture-central-project-notes-file)
                          ("Project changelog"
                           :keys "c"
                           :time-or-todo "%U"
                           :heading "Unreleased"
                           :file +org-capture-central-project-changelog-file))
               )
              )))

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))
