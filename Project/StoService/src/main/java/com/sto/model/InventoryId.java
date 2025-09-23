package com.sto.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.Hibernate;

import java.util.Objects;

@Getter
@Setter
@Embeddable
@AllArgsConstructor
@NoArgsConstructor
public class InventoryId implements java.io.Serializable {
    private static final long serialVersionUID = -1757846120624510998L;
    @NotNull
    @Column(name = "sto_id", nullable = false)
    private Integer stoId;

    @NotNull
    @Column(name = "part_id", nullable = false)
    private Integer partId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        InventoryId entity = (InventoryId) o;
        return Objects.equals(this.stoId, entity.stoId) &&
                Objects.equals(this.partId, entity.partId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(stoId, partId);
    }

}