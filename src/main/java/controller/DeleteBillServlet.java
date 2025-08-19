// src/main/java/controller/DeleteBillServlet.java
package controller;

import dao.BillDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DeleteBillServlet extends HttpServlet {

    private final BillDAO billDAO = new BillDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String billIdStr = req.getParameter("bill_id");
        if (billIdStr == null || billIdStr.trim().isEmpty()) {
            resp.sendRedirect("viewBills.jsp");
            return;
        }

        try {
            int billId = Integer.parseInt(billIdStr);
            billDAO.delete(billId);
            resp.sendRedirect("viewBills.jsp");
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid bill ID", e);
        } catch (Exception e) {
            throw new ServletException("Failed to delete bill: " + e.getMessage(), e);
        }
    }
}
