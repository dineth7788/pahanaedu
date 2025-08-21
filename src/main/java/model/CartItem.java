package model;

import java.math.BigDecimal;

public class CartItem {
    private int itemId;
    private String name;
    private BigDecimal price;
    private int qty;

    public CartItem(int itemId, String name, BigDecimal price, int qty) {
        this.itemId = itemId;
        this.name = name;
        this.price = price;
        this.qty = qty;
    }

    public int getItemId() { return itemId; }
    public String getName() { return name; }
    public BigDecimal getPrice() { return price; }
    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = Math.max(1, qty); }

    public BigDecimal getAmount() { return price.multiply(BigDecimal.valueOf(qty)); }
}
