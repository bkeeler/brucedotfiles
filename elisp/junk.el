(defun permutelist(l)
  "Return a list of all the permutations of the input list."
  (if (null l) '(())
    ;; otherwise take an element, e, out of the list.
    ;; generate all permutations of the remaining elements.
    ;; and add e to the front of each of these.
    ;; do this for all possible e to generate all permutations.
    (mapcan 
     (lambda(e)
       (mapcar 
        (lambda(p)
          (cons e p))
        (permutelist
         (remove e l ))))
     l)))

(defun powerset (lst)
  (if (null lst) '(())
    (append (powerset (cdr lst))
            (mapcar (lambda (subset)
                   (cons (car lst) subset))
                 (powerset (cdr lst))))))

(defun permute-power (l)
  (apply 'append (mapcar 'permutelist (powerset l))))
