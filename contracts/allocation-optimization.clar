;; Allocation Optimization Contract v1
;; Optimizes resource allocation based on demand and capacity

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_INVALID_ALLOCATION (err u401))
(define-constant ERR_NOT_FOUND (err u402))
(define-constant ERR_OPTIMIZATION_FAILED (err u403))

;; Data structures
(define-map allocation-requests
  uint
  {
    requester: principal,
    resource-id: (string-ascii 32),
    requested-amount: uint,
    priority: uint, ;; 1-10, 10 being highest
    deadline: uint,
    status: (string-ascii 16), ;; "pending", "approved", "rejected"
    created-at: uint
  }
)

(define-map optimized-allocations
  { resource-id: (string-ascii 32), period: uint }
  {
    total-demand: uint,
    total-capacity: uint,
    efficiency-score: uint,
    allocations: (list 10 { requester: principal, amount: uint }),
    optimizer: principal,
    created-at: uint
  }
)

(define-data-var request-counter uint u0)
(define-data-var optimization-counter uint u0)

;; Public functions
(define-public (submit-allocation-request
  (resource-id (string-ascii 32))
  (amount uint)
  (priority uint)
  (deadline uint))

  (let ((caller tx-sender)
        (request-id (+ (var-get request-counter) u1)))

    (asserts! (> amount u0) ERR_INVALID_ALLOCATION)
    (asserts! (and (>= priority u1) (<= priority u10)) ERR_INVALID_ALLOCATION)
    (asserts! (> deadline block-height) ERR_INVALID_ALLOCATION)

    ;; Store allocation request
    (map-set allocation-requests request-id {
      requester: caller,
      resource-id: resource-id,
      requested-amount: amount,
      priority: priority,
      deadline: deadline,
      status: "pending",
      created-at: block-height
    })

    (var-set request-counter request-id)
    (ok request-id)
  )
)

(define-public (optimize-allocation
  (resource-id (string-ascii 32))
  (period uint)
  (total-capacity uint))

  (let ((caller tx-sender)
        (optimization-id (+ (var-get optimization-counter) u1)))

    ;; Simple optimization: allocate based on priority
    (let ((efficiency (calculate-efficiency-score total-capacity)))

      (map-set optimized-allocations
        { resource-id: resource-id, period: period }
        {
          total-demand: u0, ;; Would be calculated from pending requests
          total-capacity: total-capacity,
          efficiency-score: efficiency,
          allocations: (list), ;; Simplified for this version
          optimizer: caller,
          created-at: block-height
        })

      (var-set optimization-counter optimization-id)
      (ok optimization-id)
    )
  )
)

(define-public (approve-allocation-request (request-id uint))
  (let ((request (unwrap! (map-get? allocation-requests request-id) ERR_NOT_FOUND)))

    ;; Update request status
    (map-set allocation-requests request-id
      (merge request { status: "approved" }))

    (ok true)
  )
)

(define-public (reject-allocation-request (request-id uint))
  (let ((request (unwrap! (map-get? allocation-requests request-id) ERR_NOT_FOUND)))

    ;; Update request status
    (map-set allocation-requests request-id
      (merge request { status: "rejected" }))

    (ok true)
  )
)

;; Private functions
(define-private (calculate-efficiency-score (capacity uint))
  ;; Simple efficiency calculation - would be more complex in production
  (if (> capacity u1000)
      u90
      (if (> capacity u500)
          u70
          u50))
)

;; Read-only functions
(define-read-only (get-allocation-request (request-id uint))
  (map-get? allocation-requests request-id)
)

(define-read-only (get-optimized-allocation (resource-id (string-ascii 32)) (period uint))
  (map-get? optimized-allocations { resource-id: resource-id, period: period })
)

(define-read-only (get-request-count)
  (var-get request-counter)
)

(define-read-only (get-optimization-count)
  (var-get optimization-counter)
)
