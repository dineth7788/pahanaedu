package controller;

import dao.CustomerDAO;
import dao.ItemDAO;
import model.Customer;
import model.Item;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/createBillForm")
public class CreateBillFormServlet extends HttpServlet {

    private CustomerDAO customerDAO;
    private ItemDAO itemDAO;

    @Override
    public void init() {
        customerDAO = new CustomerDAO();
        itemDAO = new ItemDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Customer> customers = customerDAO.getAllCustomers();
            List<Item> items = itemDAO.getAllItems();

            request.setAttribute("customers", customers);
            request.setAttribute("items", items);

            RequestDispatcher dispatcher = request.getRequestDispatcher("createBill.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading dropdown data", e);
        }
    }
}
