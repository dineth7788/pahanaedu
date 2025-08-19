package controller;

import dao.BillDAO;
import com.pahanaedu.model.BillDetails;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/billDetails")
public class BillDetailsServlet extends HttpServlet {

    private BillDAO billDAO;

    @Override
    public void init() {
        billDAO = new BillDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String billIdStr = req.getParameter("billId");

        if (billIdStr == null || billIdStr.trim().isEmpty()) {
            req.setAttribute("error", "Bill ID is required");
            forwardToView(req, resp);
            return;
        }

        try {
            int billId = Integer.parseInt(billIdStr);
            BillDetails details = billDAO.findDetails(billId);

            if (details == null) {
                req.setAttribute("error", "Bill not found");
            } else {
                req.setAttribute("billDetails", details);
            }

            forwardToView(req, resp);
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid bill ID", e);
        } catch (SQLException e) {
            throw new ServletException("Database error while retrieving bill details", e);
        }
    }

    private void forwardToView(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = req.getRequestDispatcher("billDetails.jsp");
        dispatcher.forward(req, resp);
    }
}
