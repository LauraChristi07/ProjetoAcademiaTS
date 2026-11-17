import "dotenv/config";
import mysql from "mysql2/promise";
// Um pool reaproveita as conexões em vez de abrir uma por requisição
export const banco = mysql.createPool({
host: process.env.DB_HOST ?? "localhost",
port: Number(process.env.DB_PORT ?? 3306),
user: process.env.DB_USER ?? "root",
password: process.env.DB_PASSWORD ?? "",
database: process.env.DB_NAME ?? "academia",
});
