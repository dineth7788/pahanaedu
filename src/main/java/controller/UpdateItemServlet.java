package controller;

import util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/updateItem")
public class UpdateItemServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "UPDATE items SET name=?, price=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setDouble(2, Double.parseDouble(priceStr));
            ps.setInt(3, Integer.parseInt(idStr));
            ps.executeUpdate();
            ps.close();

            response.sendRedirect("viewItems.jsp");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
