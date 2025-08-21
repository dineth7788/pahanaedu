package controller;

import dao.ItemDAO;
import model.Item;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/billing/search")
public class SearchItemServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String q = req.getParameter("q");
        try {
            List<Item> items = (q == null || q.trim().isEmpty())
                    ? Collections.emptyList()
                    : new ItemDAO().searchByName(q.trim());

            req.setAttribute("results", items);
        } catch (Exception e) {
            req.setAttribute("err", e.getMessage());
        }
        req.getRequestDispatcher("/billing_search.jsp").forward(req, resp);
    }
}
