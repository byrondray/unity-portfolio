using UnityEngine;

public class DragonController : MonoBehaviour
{
    public float moveSpeed = 5f;
    private Rigidbody2D rb;
    private Animator animator;
    private SpriteRenderer spriteRenderer;
    private Vector2 movement;

    // Animation parameter names - update these to match your animation controller
    private const string IS_MOVING = "IsMoving";

    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();
        spriteRenderer = GetComponent<SpriteRenderer>();
    }

    void Update()
    {
        // Get input
        movement.x = Input.GetAxisRaw("Horizontal");
        movement.y = Input.GetAxisRaw("Vertical");

        // Normalize diagonal movement
        movement = movement.normalized;

        // Update animation
        bool isMoving = movement.magnitude > 0.1f;
        animator.SetBool(IS_MOVING, isMoving);

        // Flip sprite based on direction
        if (movement.x != 0)
        {
            spriteRenderer.flipX = movement.x < 0;
        }
    }

    void FixedUpdate()
    {
        // Move the dragon
        rb.linearVelocity = movement * moveSpeed;
    }

    // Add this method if you want mouse following behavior instead
    public void MoveTowardsMouse()
    {
        Vector2 mousePosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
        Vector2 direction = (mousePosition - (Vector2)transform.position).normalized;
        rb.linearVelocity = direction * moveSpeed;

        // Update facing direction
        if (direction.x != 0)
        {
            spriteRenderer.flipX = direction.x < 0;
        }

        // Update animation
        animator.SetBool(IS_MOVING, rb.linearVelocity.magnitude > 0.1f);
    }
}
