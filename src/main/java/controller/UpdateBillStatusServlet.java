// src/main/java/controller/UpdateBillStatusServlet.java
package controller;

import dao.BillDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class UpdateBillStatusServlet extends HttpServlet {
    private final BillDAO billDAO = new BillDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String billIdStr = req.getParameter("bill_id");
        String status = req.getParameter("status");

        if (billIdStr == null || billIdStr.trim().isEmpty()
                || status == null || status.trim().isEmpty()) {
            resp.sendRedirect("viewBills.jsp");
            return;
        }

        try {
            int billId = Integer.parseInt(billIdStr);
            billDAO.updateStatus(billId, status);
            resp.sendRedirect("bill?bill_id=" + billId);
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid bill ID format", e);
        } catch (Exception e) {
            throw new ServletException("Failed to update status: " + e.getMessage(), e);
        }
    }
}
