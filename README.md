# 🏢 Property Management Database System (SQL)

<div align="left">
  <img src="https://www.mysql.com/common/logos/logo-mysql-170x115.png" height="50" alt="MySQL Logo" style="margin-right: 20px;" />
</div>
<br/>

**Subject:** Databases / Bases de Datos
**Tools:** MySQL, MySQL Workbench, Draw.io
**Focus:** Database Design (E-R), SQL Programming, Business Logic (Triggers)

## 👥 Authors
Project developed by:
* **Pablo Galarón Mateo**
* **Raúl Palomo Mazo**

---

This is a comprehensive project where we designed a database system from scratch for a **Property Management firm**. The system manages multiple branches, communities, neighbors, and external maintenance companies.

It covers the entire lifecycle of database creation: from requirements analysis to the implementation of automated business rules (Triggers).

### 🛠️ What we did
* **Conceptual Design:** Created the **Entity-Relationship (E-R) diagram** to model complex interactions (e.g., neighbors attending meetings, maintenance needs).
* **Logical Design:** Translated the E-R model into a **Relational Schema** (Normalization).
* **SQL Programming:** * Created the full **DDL Script** (tables, primary keys, foreign keys).
    * Developed **Triggers** to ensure data integrity (e.g., preventing a neighbor from being president of a community they don't belong to).
    * Wrote 15+ complex **Queries** using JOINS, Subqueries, and Views for decision-making.

### 💡 Key Technical Features
* **Automation:** Automated tracking of fired employees and membership dates using Triggers.
* **Integrity:** Strict validation for community meetings and presidential terms.
* **Analysis:** Queries to identify communities with high maintenance needs or salary comparisons by region.

### 📂 Files in this repo
* `📄 PabloGalarónMateo_RaúlPalomoMazo.pdf`: Complete project documentation.
* `⚙️ PabloGalarónMateo_RaúlPalomoMazo.sql`: Main script containing the full DB structure and data.
* `🔍 AdministracionFincas_CONSULTAS.sql`: Advanced SQL queries for data analysis.
* `⚡ AdministracionFincas_TRIGGERS.sql`: Automation and validation logic.
* `📐 AdministracionFincas_DIBUJO.drawio`: Editable E-R diagram file.

---

Este es un proyecto integral donde diseñamos desde cero un sistema de base de datos para una **empresa de Administración de Fincas**. El sistema gestiona múltiples sedes, comunidades de vecinos, propietarios y empresas externas de mantenimiento.

Cubre todo el ciclo de vida de una base de datos: desde el análisis de requisitos hasta la implementación de reglas de negocio automatizadas (Triggers).

### 🛠️ Qué hicimos
* **Diseño Conceptual:** Creamos el **diagrama Entidad-Relación (E-R)** para modelar interacciones complejas (ej: asistencia a reuniones, necesidades de mantenimiento).
* **Diseño Lógico:** Traducimos el modelo E-R a un **Esquema Relacional** (Normalización).
* **Programación SQL:** * Creamos el **Script DDL** completo (tablas, claves primarias y foráneas).
    * Desarrollamos **Triggers** para asegurar la integridad de los datos (ej: evitar que un vecino sea presidente de una comunidad a la que no pertenece).
    * Redactamos más de 15 **Consultas (Queries)** complejas usando JOINS, subconsultas y Vistas.

### 💡 Aspectos Técnicos Clave
* **Automatización:** Seguimiento automático de bajas de empleados e historial de propietarios mediante Triggers.
* **Integridad:** Validación estricta para reuniones comunitarias y mandatos presidenciales.
* **Análisis:** Consultas para identificar comunidades con muchas averías o comparativas salariales por región.

### 📂 Archivos en este repo
* `📄 PabloGalarónMateo_RaúlPalomoMazo.pdf`: Documentación completa del proyecto.
* `⚙️ PabloGalarónMateo_RaúlPalomoMazo.sql`: Script principal con estructura y datos.
* `🔍 AdministracionFincas_CONSULTAS.sql`: Consultas SQL avanzadas.
* `⚡ AdministracionFincas_TRIGGERS.sql`: Lógica de automatización y validación.
* `📐 AdministracionFincas_DIBUJO.drawio`: Diagrama E-R editable.
