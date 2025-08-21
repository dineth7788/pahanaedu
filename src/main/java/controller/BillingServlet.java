package controller;

import dao.CustomerDAO;
import dao.ItemDAO;
import model.Cart;
import model.CartItem;
import model.Item;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {

    private Cart getCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute("CART");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("CART", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Map<Integer, String> customers = new CustomerDAO().mapAll();
            req.setAttribute("customers", customers);
        } catch (Exception e) {
            req.setAttribute("err", e.getMessage());
        }
        req.getRequestDispatcher("/billing.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Cart cart = getCart(session);
        String action = req.getParameter("action");

        try {
            if ("selectCustomer".equals(action)) {
                int id = Integer.parseInt(req.getParameter("customerId"));
                String name = new CustomerDAO().findName(id);
                cart.setCustomer(id, name);

            } else if ("addItem".equals(action)) {
                int itemId = Integer.parseInt(req.getParameter("itemId"));
                int qty    = Integer.parseInt(req.getParameter("qty"));

                ItemDAO itemDAO = new ItemDAO();
                Item it = itemDAO.findById(itemId);
                if (it == null) throw new IllegalArgumentException("Item not found");

                BigDecimal price = itemDAO.findPriceById(itemId);
                if (price == null) price = BigDecimal.ZERO;

                cart.add(new CartItem(it.getId(), it.getName(), price, qty));

            } else if ("updateQty".equals(action)) {
                int itemId = Integer.parseInt(req.getParameter("itemId"));
                int qty    = Integer.parseInt(req.getParameter("qty"));
                cart.updateQty(itemId, qty);

            } else if ("remove".equals(action)) {
                int itemId = Integer.parseInt(req.getParameter("itemId"));
                cart.remove(itemId);

            } else if ("clear".equals(action)) {
                cart.clear();
            }
        } catch (Exception ex) {
            req.setAttribute("err", ex.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/billing");
    }
}
