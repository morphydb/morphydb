// Neo4J

MATCH (n) DETACH DELETE n;

DROP INDEX ix_position_fen IF EXISTS;

DROP INDEX ix_opening_eco IF EXISTS;
DROP INDEX ix_opening_name IF EXISTS;

CREATE INDEX ix_position_fen FOR (p:Position) ON (p.fen);

CREATE INDEX ix_opening_eco FOR (o:Opening) ON (o.eco);
CREATE INDEX ix_opening_name FOR (o:Opening) ON (o.name);

// fen
:auto LOAD CSV WITH HEADERS FROM 'file:///positions.csv' AS line
CALL {
    WITH line
    CREATE (p: Position)
    SET p.fen = line.fen
} IN TRANSACTIONS;

// from_fen,to_fen,move
:auto LOAD CSV WITH HEADERS FROM 'file:///moves.csv' AS line
CALL {
    WITH line
    MATCH (from: Position{fen: line.from_fen})
    MATCH (to: Position{fen: line.to_fen})
    CREATE (from)-[:MOVES{san: line.move}]->(to)
} IN TRANSACTIONS;

// fen,eco,name
:auto LOAD CSV WITH HEADERS FROM 'file:///openings.csv' AS line
CALL {
    WITH line
    MATCH (p: Position{fen: line.fen})
    MERGE (o: Opening{eco: line.eco, name: line.name})
    CREATE (p)-[:OPENING]->(o)
} IN TRANSACTIONS;
