module CreateTableHouses

import SearchLight.Migrations: create_table, column, columns, pk, add_index, drop_table, add_indices

function up()
    create_table(:houses) do
    [
            pk()
            # column(:column_name, :column_type)
            columns([
                :CRIM => :float,
                :ZN => :float,
                :INDUS => :float,
                :CHAS => :float,
                :NOX => :float,
                :RM => :float,
                :AGE => :float,
                :DIS => :float,
                :RAD => :float,
                :TAX => :float,
                :PTRATIO => :float,
                :B => :float,
                :LSTAT => :float,
                :MEDV => :float,
            ])
        ]
    end
end

function down()
    drop_table(:houses)
end

end

