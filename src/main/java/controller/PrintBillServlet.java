package controller;

import dao.BillDAO;
import model.Cart;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/billing/print")
public class PrintBillServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Cart cart = (Cart) req.getSession().getAttribute("CART");
        if (cart == null || cart.isEmpty() || cart.getCustomerId() == null) {
            // Need a customer and at least one item
            resp.sendRedirect(req.getContextPath() + "/billing");
            return;
        }

        try {
            int billId = new BillDAO().checkout(cart);
            req.setAttribute("orderId", billId);   // reuse attribute name used by JSP
            req.setAttribute("cart", cart);
            // Clear for next sale
            req.getSession().removeAttribute("CART");
            req.getRequestDispatcher("/printBill.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("err", e.getMessage());
            req.getRequestDispatcher("/billing.jsp").forward(req, resp);
        }
    }
}
