(define-constant admin 'SP000000000000000000002Q6VF78)

;; Stores karma score and the last reason
(define-map karma-points
  {user: principal}
  {score: uint, reason: (string-ascii 100)}
)

;; Stores the last recipient of karma from each user
(define-map karma-history
  {giver: principal}
  {last-recipient: principal}
)

;; Tracks banned users as a map (principal -> bool)
(define-map banned-users
  {user: principal}
  {banned: bool}
)

;; Helper function to check admin
(define-private (is-admin (sender principal))
  (is-eq sender admin)
)

;; Public: Give karma to another user
(define-public (give-karma (recipient principal) (reason (string-ascii 100)))
  (begin
    ;; Prevent banned users from giving karma
(asserts! (not (is-eq (default-to false (get banned (map-get? banned-users {user: tx-sender}))) true)) (err "You are banned from giving karma"))
    ;; Prevent self-karma
    (asserts! (not (is-eq recipient tx-sender)) (err "Cannot give karma to yourself"))
    ;; Prevent repeated karma to same person
(let ((last-recipient (get last-recipient (map-get? karma-history {giver: tx-sender}))))
  (match last-recipient r
    (asserts! (not (is-eq r recipient)) (err "You already gave karma to this user. Try someone else."))
    true
  )
)
    ;; Get current score
  (let ((checked-recipient recipient)
        (checked-reason reason)
        (checked-sender tx-sender))
    (let ((existing (default-to {score: u0, reason: ""} (map-get? karma-points {user: checked-recipient}))))
      (let ((checked-score (+ (get score existing) u1)))
        (begin
          (let ((cr checked-recipient)
                (cs checked-score)
                (crs checked-reason))
            (map-set karma-points {user: cr} {
              score: cs,
              reason: crs
            })
          )
          (map-set karma-history {giver: checked-sender} {last-recipient: checked-recipient})
          (print {event: "karma-given", from: checked-sender, to: checked-recipient, reason: checked-reason})
          (ok "Karma successfully given!")
        )
      )
    )
  )
  )
)

;; Read-only: Get a user's karma score and reason
(define-read-only (get-karma (user principal))
(default-to {score: u0, reason: "No karma yet"} (map-get? karma-points {user: user}))
)

;; Admin: Reset karma for a user
(define-public (reset-karma (user principal))
  (begin
    (asserts! (is-admin tx-sender) (err "Not authorized"))
  (let ((checked-user user))
    (map-set karma-points {user: checked-user} {score: u0, reason: "Reset by admin"})
  )
    (print {event: "karma-reset", user: user})
    (ok "Karma reset successfully")
  )
)

;; Admin: Ban a user from giving karma
(define-public (ban-user (user principal))
  (begin
    (asserts! (is-admin tx-sender) (err "Not authorized"))
  (let ((checked-user user))
    (map-set banned-users {user: checked-user} {banned: true})
  )
    (print {event: "user-banned", user: user})
    (ok "User banned from giving karma")
  )
)

;; Admin: Unban a user
(define-public (unban-user (user principal))
  (begin
    (asserts! (is-admin tx-sender) (err "Not authorized"))
  (let ((checked-user user))
    (map-delete banned-users {user: checked-user})
  )
    (print {event: "user-unbanned", user: user})
    (ok "User unbanned")
  )
)

;; Read-only: Check if a user is banned
(define-read-only (is-banned (user principal))
(ok (is-eq (default-to false (get banned (map-get? banned-users {user: user}))) true))
)
