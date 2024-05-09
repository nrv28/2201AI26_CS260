
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


router.get('/payment_complete', requireLogin, (req, res) => {
    // Read the HTML file
    const filePath = path.join(__dirname, '..', 'views', 'payment_complete9.html');
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


router.post('/payment_complete', (req, res) => {
   
    const {
        my_state,
        decl_status
    } = req.body;

    // Retrieve Application_id from session (assuming it's stored in req.session)
    const Application_id = req.session.loggedInUser.Application_id;

    // Database connection (assuming req.db provides database connection)
    const db = req.db;


    if(decl_status){
        res.redirect('/finalpdf');
    }

    else{
        res.status(400).send("Checkbox error");
    }

  
    // db.query(insertOrUpdateQuery, values, (error, results) => {
    //     if (error) {
    //         console.error("Error occurred:", error);
    //         res.status(500).send("Error occurred while saving data.");
    //     } else {
    //         // Check if any rows were affected (inserted or updated)
    //         if (results.affectedRows > 0) {
    //             // res.status(200).send("Data saved successfully.");
    //             res.redirect('/payment_complete');
    //         } else {
    //             res.status(400).send("No data saved.");
    //         }
    //     }
    // });
});





module.exports = router;
