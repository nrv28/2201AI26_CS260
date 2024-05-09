
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


router.get('/employment', requireLogin, (req, res) => {
    // Read the HTML file
    const filePath = path.join(__dirname, '..', 'views', 'employment_details3.html');
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
        const modifiedHtml = html.replace('<strong>{{ firstName }} {{ lastName }}</strong>', `<strong>${firstName} ${lastName}</strong>`);
        
        
        // Send the modified HTML content as the response
        res.send(modifiedHtml);
    });
});

router.post('/employment', (req, res) => {
    const {
        pres_emp_position,
        pres_emp_employer,
        pres_status,
        pres_emp_doj,
        pres_emp_dol,
        pres_emp_duration,
        position,
        employer,
        doj,
        dol,
        exp_duration,
        r_exp_position,
        r_exp_institute,
        r_exp_supervisor,
        r_exp_doj,
        r_exp_dol,
        r_exp_duration,
        org,
        workk,
        ind_doj,
        ind_dol,
        period,
        area_spl,
        area_rese
    } = req.body;



    // Get the logged-in user's Application_id from the session
    const Application_id = req.session.loggedInUser.Application_id;

    // Retrieve the database connection from req.db
    const db = req.db;

    // Prepare the SQL query for inserting or updating employment details
    const insertQuery = `
        INSERT INTO employment_details (
            pres_emp_position,
            pres_emp_employer,
            pres_status,
            pres_emp_doj,
            pres_emp_dol,
            pres_emp_duration,
            position,
            employer,
            doj,
            dol,
            exp_duration,
            r_exp_position,
            r_exp_institute,
            r_exp_supervisor,
            r_exp_doj,
            r_exp_dol,
            r_exp_duration,
            org,
            workk,
            ind_doj,
            ind_dol,
            period,
            Application_id,
            area_spl,
            area_rese
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
            pres_emp_position = VALUES(pres_emp_position),
            pres_emp_employer = VALUES(pres_emp_employer),
            pres_status = VALUES(pres_status),
            pres_emp_doj = VALUES(pres_emp_doj),
            pres_emp_dol = VALUES(pres_emp_dol),
            pres_emp_duration = VALUES(pres_emp_duration),
            position = VALUES(position),
            employer = VALUES(employer),
            doj = VALUES(doj),
            dol = VALUES(dol),
            exp_duration = VALUES(exp_duration),
            r_exp_position = VALUES(r_exp_position),
            r_exp_institute = VALUES(r_exp_institute),
            r_exp_supervisor = VALUES(r_exp_supervisor),
            r_exp_doj = VALUES(r_exp_doj),
            r_exp_dol = VALUES(r_exp_dol),
            r_exp_duration = VALUES(r_exp_duration),
            org = VALUES(org),
            workk = VALUES(workk),
            ind_doj = VALUES(ind_doj),
            ind_dol = VALUES(ind_dol),
            period = VALUES(period),
            area_spl=VALUES(area_spl),
            area_rese = VALUES(area_rese)
    `;

    const values = [
        pres_emp_position,
        pres_emp_employer,
        pres_status,
        pres_emp_doj,
        pres_emp_dol,
        pres_emp_duration,
        position,
        employer,
        doj,
        dol,
        exp_duration,
        r_exp_position,
        r_exp_institute,
        r_exp_supervisor,
        r_exp_doj,
        r_exp_dol,
        r_exp_duration,
        org,
        workk,
        ind_doj,
        ind_dol,
        period,
        Application_id,
        area_spl,
        area_rese
    ];

    // Execute the SQL query with prepared values
    db.query(insertQuery, values, (error, results, fields) => {
        if (error) {
            console.log(error);
            res.status(500).send("Error occurred while inserting/updating employment details.");
        } else {
            if (results.affectedRows > 0) {
                // res.status(200).send("Employment details inserted/updated successfully.");
                res.redirect('/publish');
            } else {
                res.status(400).send("No employment details inserted/updated.");
            }
        }
    });
});


module.exports = router;
