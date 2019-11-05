(defcustom elpy-utils-scale 1.0
  "Scale ratio of image."
  :group 'elpy-utils
  :type 'float)

(defun elpy-utils--replace-image-filter (_)
  (elpy-utils--replace-images))

(defun elpy-utils--replace-images ()
  "Replace all image patterns with actual images"
  ;; Adapted from racket-mode repl
  (with-silent-modifications
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward  "#<Image: \\(.+\\)>" nil t)
        (message "Found match")
        (let* ((file (match-string 1))
               (begin (match-beginning 0))
               (end (match-end 0)))
          (delete-region begin end)
          (goto-char begin)
          (if (display-images-p)
              (progn (message "inserting image")
                     (insert-image (create-image file
                                                 'imagemagick
                                                 ;; 'png
                                                 nil
                                                 :scale elpy-utils-scale
                                                 ;; :height 100
                                                 ) "[image]"))
            (goto-char begin)
            (insert "[image] ; use M-x racket-view-last-image to view")))))))

(defun elpy-utils--enable-output-filter ()
  (add-hook 'comint-output-filter-functions #'elpy-utils--replace-image-filter nil t))

;; I actually do not need to autoload.
;; ###autoload
(defun elpy-utils-enable ()
  (interactive)
  (add-hook 'inferior-python-mode-hook 'elpy-utils--enable-output-filter))

;; TODO use?
(defun elpy-utils-disable ()
  (remove-hook 'inferior-python-mode-hook 'elpy-utils--enable-output-filter))

(provide 'elpy-utils)
