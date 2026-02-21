;;; yerba mate blending — a tiny DSL in Scheme

(define *steep-rounds* 12)
(define *water-temp* 70.0)

;; Blend constructor and accessors
(define (make-blend name origin grams flavors)
  (list 'blend name origin grams flavors))

(define (blend-name b)    (cadr b))
(define (blend-origin b)  (caddr b))
(define (blend-grams b)   (cadddr b))
(define (blend-flavors b) (car (cddddr b)))

;; Build a collection of blends
(define collection
  (list
    (make-blend "Canarias"  "Brazil"    50.0 '(earthy))
    (make-blend "Taragui"   "Argentina" 40.0 '(earthy smoky))
    (make-blend "Pajarito"  "Paraguay"  35.5 '(citrus herbal))
    (make-blend "Kurupi"    "Paraguay"  28.0 '(herbal))))

;; Filter blends by flavor tag
(define (has-flavor? blend flavor)
  (memq flavor (blend-flavors blend)))

(define (filter-by-flavor blends flavor)
  (cond
    ((null? blends) '())
    ((has-flavor? (car blends) flavor)
     (cons (car blends) (filter-by-flavor (cdr blends) flavor)))
    (else (filter-by-flavor (cdr blends) flavor))))

;; Fold over blends to compute total weight
(define (total-weight blends)
  (if (null? blends)
      0.0
      (+ (blend-grams (car blends))
         (total-weight (cdr blends)))))

;; Steep simulation: returns list of strength values
(define (steep-strengths rounds)
  (let loop ((n 1) (acc '()))
    (if (> n rounds)
        (reverse acc)
        (let ((strength (max 0.0 (- 1.0 (/ n (+ rounds 1))))))
          (loop (+ n 1) (cons strength acc))))))

;; Display a single blend
(define (display-blend b)
  (display (blend-name b))
  (display " — ")
  (display (blend-grams b))
  (display "g from ")
  (display (blend-origin b))
  (display " [")
  (for-each
    (lambda (f)
      (display f)
      (display " "))
    (blend-flavors b))
  (display "]")
  (newline))

;; Main
(for-each display-blend collection)

(newline)
(display "earthy blends: ")
(for-each
  (lambda (b) (display (blend-name b)) (display " "))
  (filter-by-flavor collection 'earthy))
(newline)

(display "total: ")
(display (total-weight collection))
(display "g across ")
(display (length collection))
(display " blends")
(newline)
