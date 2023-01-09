module CreateTablePredictions

import SearchLight.Migrations: create_table, column, columns, pk, add_index, drop_table, add_indices

function up()
    create_table(:predictions) do
    [
            pk()
            columns([
                :price => :float,
                :error => :float,
                :timestamp => :string,
            ])
        ]
    end
    add_index(:predictions, :id)
end

function down()
    drop_table(:predictions)
end

end
