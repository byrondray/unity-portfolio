using UnityEngine;

public class DragonController : MonoBehaviour
{
    public float moveSpeed = 5f;
    private Rigidbody2D rb;
    private Animator animator;
    private SpriteRenderer spriteRenderer;
    private Vector2 movement;

    // Animation parameter names - update these to match your animation controller
    private const string IS_MOVING = "isMoving"; // Changed to lowercase to match Unity's default naming

    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();
        spriteRenderer = GetComponent<SpriteRenderer>();

        // More detailed debug checks
        if (animator == null)
            Debug.LogError("Animator component not found!");
        else
        {
            Debug.Log("Animator found and initialized");
            // Check if parameter exists
            AnimatorControllerParameter[] parameters = animator.parameters;
            bool foundParameter = false;
            foreach (var param in parameters)
            {
                Debug.Log($"Found parameter: {param.name} of type {param.type}");
                if (param.name == IS_MOVING)
                    foundParameter = true;
            }
            if (!foundParameter)
                Debug.LogError($"Parameter {IS_MOVING} not found in animator!");
        }
    }

    void Update()
    {
        // Get input
        movement.x = Input.GetAxisRaw("Horizontal");
        movement.y = Input.GetAxisRaw("Vertical");

        // Normalize diagonal movement
        movement = movement.normalized;

        // Update animation with more debug info
        bool isMoving = movement.magnitude > 0.1f;
        animator.SetBool(IS_MOVING, isMoving);
        Debug.Log(
            $"Setting isMoving to {isMoving}. Current animator state: {animator.GetCurrentAnimatorStateInfo(0).fullPathHash}"
        );

        // Flip sprite based on direction
        if (movement.x != 0)
        {
            spriteRenderer.flipX = movement.x < 0;
        }
    }

    void FixedUpdate()
    {
        // Move the dragon
        rb.linearVelocity = movement * moveSpeed; // Changed to velocity
    }

    // Add this to check what's happening in the animator
    void OnAnimatorMove()
    {
        Debug.Log("Animator is moving");
    }
}
