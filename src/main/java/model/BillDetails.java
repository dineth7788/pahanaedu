package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class BillDetails {
    private int billId;
    private int customerId;
    private String customerName;
    private Timestamp billDate;
    private BigDecimal total;
    private String status;
    private List<BillItemLine> items = new ArrayList<>();

    public void addItem(int itemId, String itemName, int quantity, BigDecimal price, BigDecimal subtotal) {
        items.add(new BillItemLine(itemId, itemName, quantity, price, subtotal));
    }

    // getters and setters
    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public Timestamp getBillDate() { return billDate; }
    public void setBillDate(Timestamp billDate) { this.billDate = billDate; }

    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<BillItemLine> getItems() { return items; }

    // Inner class for line items
    public static class BillItemLine {
        private int itemId;
        private String itemName;
        private int quantity;
        private BigDecimal price;
        private BigDecimal subtotal;

        public BillItemLine(int itemId, String itemName, int quantity, BigDecimal price, BigDecimal subtotal) {
            this.itemId = itemId;
            this.itemName = itemName;
            this.quantity = quantity;
            this.price = price;
            this.subtotal = subtotal;
        }

        public int getItemId() { return itemId; }
        public String getItemName() { return itemName; }
        public int getQuantity() { return quantity; }
        public BigDecimal getPrice() { return price; }
        public BigDecimal getSubtotal() { return subtotal; }
    }
}
