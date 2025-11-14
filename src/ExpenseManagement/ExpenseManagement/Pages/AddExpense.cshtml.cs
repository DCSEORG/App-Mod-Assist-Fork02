using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ExpenseManagement.Pages
{
    public class AddExpenseModel : PageModel
    {
        [BindProperty]
        public decimal Amount { get; set; }

        [BindProperty]
        public DateTime Date { get; set; } = DateTime.Now;

        [BindProperty]
        public string Category { get; set; } = "Travel";

        [BindProperty]
        public string Description { get; set; } = string.Empty;

        public void OnGet()
        {
        }

        public IActionResult OnPost()
        {
            // No backend processing as per requirements
            // Just accept the form submission
            return RedirectToPage("/Expenses");
        }
    }
}
