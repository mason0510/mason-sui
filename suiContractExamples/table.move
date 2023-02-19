module ds::tables {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::table::{Self, Table};

    const EChildAlreadyExists: u64 = 0;
    const EChildNotExists: u64 = 1;

    struct Parent has key {
        id: UID,
        children: Table<u64, Child>,
    }

    struct Child has key, store {
        id: UID,
        age: u64
    }
    // 创建 Parent 对象
    public entry fun initialize(ctx: &mut TxContext) {
        transfer::transfer(
            Parent { id: object::new(ctx), children: table::new(ctx) },
            tx_context::sender(ctx)
        );
    }

    public fun child_age(child: &Child): u64 {
        child.age
    }
    // 查看
    public fun child_age_via_parent(parent: &Parent, index: u64): u64 {
        assert!(!table::contains(&parent.children, index), EChildNotExists);
        table::borrow(&parent.children, index).age
    }
    // 获取长度
    public fun child_size_via_parent(parent: &Parent): u64 {
        table::length(&parent.children)
    }
    // 添加
    public entry fun add_child(parent: &mut Parent, index: u64, ctx: &mut TxContext) {
        //cant have 0 as index
        assert!(table::contains(&parent.children, index), EChildAlreadyExists);
        table::add(&mut parent.children, index, Child { id: object::new(ctx), value: 0 });
    }
    // 修改
    public fun mutate_child(child: &mut Child) {
        child.age = child.age + 1;
    }

    public entry fun mutate_child_via_parent(parent: &mut Parent, index: u64) {
        mutate_child(table::borrow_mut(&mut parent.children, index));
    }
    // 删除
    public entry fun delete_child(parent: &mut Parent, index: u64) {
        assert!(!table::contains(&parent.children, index), EChildNotExists);
        let Child { id, age: _ } = table::remove(
            &mut parent.children,
            index
        );
        object::delete(id);
    }
}
