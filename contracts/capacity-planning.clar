;; Capacity Planning Contract v1
;; Manages resource capacity planning and allocation

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u300))
(define-constant ERR_INVALID_CAPACITY (err u301))
(define-constant ERR_INSUFFICIENT_CAPACITY (err u302))
(define-constant ERR_NOT_FOUND (err u303))

;; Data structures
(define-map resource-capacity
  (string-ascii 32)
  {
    total-capacity: uint,
    available-capacity: uint,
    reserved-capacity: uint,
    manager: principal,
    last-updated: uint
  }
)

(define-map capacity-reservations
  { resource-id: (string-ascii 32), requester: principal }
  {
    reserved-amount: uint,
    reservation-period: uint,
    created-at: uint,
    active: bool
  }
)

(define-data-var total-resources uint u0)

;; Public functions
(define-public (register-resource-capacity
  (resource-id (string-ascii 32))
  (total-capacity uint))

  (let ((caller tx-sender))
    (asserts! (> total-capacity u0) ERR_INVALID_CAPACITY)
    (asserts! (is-none (map-get? resource-capacity resource-id)) ERR_INVALID_CAPACITY)

    ;; Register new resource capacity
    (map-set resource-capacity resource-id {
      total-capacity: total-capacity,
      available-capacity: total-capacity,
      reserved-capacity: u0,
      manager: caller,
      last-updated: block-height
    })

    (var-set total-resources (+ (var-get total-resources) u1))
    (ok true)
  )
)

(define-public (reserve-capacity
  (resource-id (string-ascii 32))
  (amount uint)
  (period uint))

  (let ((caller tx-sender)
        (capacity (unwrap! (map-get? resource-capacity resource-id) ERR_NOT_FOUND))
        (reservation-key { resource-id: resource-id, requester: caller }))

    (asserts! (>= (get available-capacity capacity) amount) ERR_INSUFFICIENT_CAPACITY)
    (asserts! (> amount u0) ERR_INVALID_CAPACITY)

    ;; Create reservation
    (map-set capacity-reservations reservation-key {
      reserved-amount: amount,
      reservation-period: period,
      created-at: block-height,
      active: true
    })

    ;; Update capacity
    (map-set resource-capacity resource-id
      (merge capacity {
        available-capacity: (- (get available-capacity capacity) amount),
        reserved-capacity: (+ (get reserved-capacity capacity) amount),
        last-updated: block-height
      }))

    (ok true)
  )
)

(define-public (release-capacity
  (resource-id (string-ascii 32))
  (requester principal))

  (let ((reservation-key { resource-id: resource-id, requester: requester })
        (reservation (unwrap! (map-get? capacity-reservations reservation-key) ERR_NOT_FOUND))
        (capacity (unwrap! (map-get? resource-capacity resource-id) ERR_NOT_FOUND)))

    (asserts! (get active reservation) ERR_NOT_FOUND)

    ;; Deactivate reservation
    (map-set capacity-reservations reservation-key
      (merge reservation { active: false }))

    ;; Update capacity
    (let ((reserved-amount (get reserved-amount reservation)))
      (map-set resource-capacity resource-id
        (merge capacity {
          available-capacity: (+ (get available-capacity capacity) reserved-amount),
          reserved-capacity: (- (get reserved-capacity capacity) reserved-amount),
          last-updated: block-height
        }))
    )

    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-resource-capacity (resource-id (string-ascii 32)))
  (map-get? resource-capacity resource-id)
)

(define-read-only (get-reservation (resource-id (string-ascii 32)) (requester principal))
  (map-get? capacity-reservations { resource-id: resource-id, requester: requester })
)

(define-read-only (get-available-capacity (resource-id (string-ascii 32)))
  (match (map-get? resource-capacity resource-id)
    capacity (some (get available-capacity capacity))
    none
  )
)

(define-read-only (get-total-resources)
  (var-get total-resources)
)
