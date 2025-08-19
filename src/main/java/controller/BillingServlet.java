package controller;

import dao.CustomerDAO;
import dao.ItemDAO;
import dao.BillDAO;
import model.Customer;
import model.Item;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/createBill")
public class BillingServlet extends HttpServlet {

    private CustomerDAO customerDAO;
    private ItemDAO itemDAO;
    private BillDAO billDAO;

    @Override
    public void init() {
        customerDAO = new CustomerDAO();
        itemDAO = new ItemDAO();
        billDAO = new BillDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Customer> customers = customerDAO.getAllCustomers();
            List<Item> items = itemDAO.getAllItems();
            req.setAttribute("customers", customers);
            req.setAttribute("items", items);

            RequestDispatcher dispatcher = req.getRequestDispatcher("createBill.jsp");
            dispatcher.forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Error loading Create Bill form data", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            processBill(req);
            resp.sendRedirect("viewBills");
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid numeric input", e);
        } catch (SQLException e) {
            throw new ServletException("Database error while creating bill", e);
        }
    }

    /**
     * Shared bill creation logic to avoid duplicate code.
     */
    private void processBill(HttpServletRequest req) throws SQLException, ServletException {
        int customerId = Integer.parseInt(req.getParameter("customer_id"));
        int itemId = Integer.parseInt(req.getParameter("item_id"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));

        BigDecimal price = itemDAO.findPriceById(itemId);
        if (price == null) {
            throw new ServletException("Selected item not found");
        }

        BigDecimal total = price.multiply(BigDecimal.valueOf(quantity));
        billDAO.createBill(customerId, itemId, quantity, total);
    }
}
