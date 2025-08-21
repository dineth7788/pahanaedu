package model;

import java.math.BigDecimal;
import java.util.*;

public class Cart {
    private final Map<Integer, CartItem> items = new LinkedHashMap<>();
    private Integer customerId;
    private String customerName;

    public Map<Integer, CartItem> getItems() { return items; }

    public void setCustomer(Integer id, String name) {
        this.customerId = id;
        this.customerName = name;
    }
    public Integer getCustomerId() { return customerId; }
    public String getCustomerName() { return customerName; }

    public void add(CartItem ci) {
        CartItem existing = items.get(ci.getItemId());
        if (existing == null) items.put(ci.getItemId(), ci);
        else existing.setQty(existing.getQty() + ci.getQty());
    }

    public void updateQty(int itemId, int qty) {
        CartItem ci = items.get(itemId);
        if (ci != null) ci.setQty(qty);
    }

    public void remove(int itemId) { items.remove(itemId); }
    public void clear() { items.clear(); customerId = null; customerName = null; }

    public BigDecimal getTotal() {
        return items.values().stream()
                .map(CartItem::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public boolean isEmpty() { return items.isEmpty(); }
}
