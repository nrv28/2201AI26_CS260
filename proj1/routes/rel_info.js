

const express = require("express")
const path = require("path");
const router = express.Router();
const fs = require('fs');

function requireLogin(req, res, next) {
    if (req.session.loggedInUser) {
        // User is logged in, proceed to next middleware
        next();
    } else {
        // User is not logged in, redirect to login page
        res.redirect('/');
    }
}

router.get('/rel_info', requireLogin, (req, res) => {
    // Read the HTML file
    const filePath = path.join(__dirname, '..', 'views', 'rel_info7.html');
    fs.readFile(filePath, 'utf8', function(err, html) {
        if (err) {
            // If there's an error reading the file, send an error response
            return res.status(500).send('Error reading file');
        }

        // Extract user data
        const firstName = req.session.loggedInUser.firstName;
        const lastName = req.session.loggedInUser.lastName;
        const email = req.session.loggedInUser.email;
        const Application_id = req.session.loggedInUser.Application_id;

        // Replace placeholders in HTML with user data
        const modifiedHtml = html.replace('<strong>{{ firstName }} {{ lastName }}</strong>', `<strong>${firstName} ${lastName}</strong>`)

        

        // Send the modified HTML content as the response
        res.send(modifiedHtml);
    });
});


router.post('/rel_info', (req, res) => {
    // Retrieve data from request body
    const {
        conf_details,
        jour_details,
        prof_serv,
        rel_in,
        teaching_statement,
        research_statement
    } = req.body;

    // Retrieve Application_id from session (assuming it's stored in req.session)
    const Application_id = req.session.loggedInUser.Application_id;

    // Database connection (assuming req.db provides database connection)
    const db = req.db;

    // SQL query to insert or update data in the rel_info table
    const insertOrUpdateQuery = `
        INSERT INTO rel_info (
            conf_details,
            jour_details,
            prof_serv,
            rel_in,
            teaching_statement,
            research_statement,
            Application_id
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
            conf_details = VALUES(conf_details),
            jour_details = VALUES(jour_details),
            prof_serv = VALUES(prof_serv),
            rel_in = VALUES(rel_in),
            teaching_statement = VALUES(teaching_statement),
            research_statement = VALUES(research_statement)
    `;

    const values = [
        conf_details,
        jour_details,
        prof_serv,
        rel_in,
        teaching_statement,
        research_statement,
        Application_id
    ];

    // Execute the SQL query
    db.query(insertOrUpdateQuery, values, (error, results) => {
        if (error) {
            console.error("Error occurred:", error);
            res.status(500).send("Error occurred while saving data.");
        } else {
            // Check if any rows were affected (inserted or updated)
            if (results.affectedRows > 0) {
                // res.status(200).send("Data saved successfully.");
                res.redirect('/submission_complete');
            } else {
                res.status(400).send("No data saved.");
            }
        }
    });
});



module.exports = router;
