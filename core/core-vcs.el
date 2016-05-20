;;; core-vcs.el --- version control awareness

(use-package gitconfig-mode
  :mode ("/\\.?git/?config$" "/\\.gitmodules$")
  :init (add-hook 'gitconfig-mode-hook 'flyspell-mode))

(use-package gitignore-mode
  :mode ("/\\.gitignore$"
         "/\\.git/info/exclude$"
         "/git/ignore$"))

(use-package git-gutter
  :commands (git-gutter-mode narf/vcs-next-hunk narf/vcs-prev-hunk
             narf/vcs-show-hunk narf/vcs-stage-hunk narf/vcs-revert-hunk)
  :init
  (add-hook! (text-mode prog-mode conf-mode) 'git-gutter-mode)
  :config
  (require 'git-gutter-fringe)

  (define-fringe-bitmap 'git-gutter-fr:added
    [224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224]
    nil nil 'center)
  (define-fringe-bitmap 'git-gutter-fr:modified
    [224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224]
    nil nil 'center)
  (define-fringe-bitmap 'git-gutter-fr:deleted
    [0 0 0 0 0 0 0 0 0 0 0 0 0 128 192 224 240 248]
    nil nil 'center)

  ;; Refreshing git-gutter
  (advice-add 'evil-force-normal-state :after 'git-gutter)
  (add-hook 'focus-in-hook 'git-gutter:update-all-windows)

  (defalias 'narf/vcs-next-hunk    'git-gutter:next-hunk)
  (defalias 'narf/vcs-prev-hunk    'git-gutter:previous-hunk)
  (defalias 'narf/vcs-show-hunk    'git-gutter:popup-hunk)
  (defalias 'narf/vcs-stage-hunk   'git-gutter:stage-hunk)
  (defalias 'narf/vcs-revert-hunk  'git-gutter:revert-hunk))

(after! vc-annotate
  (evil-set-initial-state 'vc-annotate-mode     'normal)
  (evil-set-initial-state 'vc-git-log-view-mode 'normal)
  (map! :map vc-annotate-mode-map
        :n "q" 'kill-this-buffer
        :n "d" 'vc-annotate-show-diff-revision-at-line
        :n "D" 'vc-annotate-show-changeset-diff-revision-at-line
        :n "SPC" 'vc-annotate-show-log-revision-at-line
        :n "]]" 'vc-annotate-next-revision
        :n "[[" 'vc-annotate-prev-revision
        :n [tab] 'vc-annotate-toggle-annotation-visibility
        :n "RET" 'vc-annotate-find-revision-at-line))

(use-package browse-at-remote
  :commands (browse-at-remote/browse browse-at-remote/to-clipboard))

(provide 'core-vcs)
;;; core-vcs.el ends here
