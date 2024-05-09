

const express = require("express")
const path = require("path");
const router = express.Router();
const fs = require('fs');
const { last } = require("pdf-lib");

function requireLogin(req, res, next) {
    if (req.session.loggedInUser) {
        // User is logged in, proceed to next middleware
        next();
    } else {
        // User is not logged in, redirect to login page
        res.redirect('/');
    }
}

router.get('/finalpdf', requireLogin, (req, res) => {
    const filePath = path.join(__dirname, '..', 'views', 'finalpdf.html');
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


        const modifiedHtml=html.replace('<td>{{Gennedy}}</td>',`<td>${firstName}</td>`)
                                .replace('<div class="title">{{First Name}} {{Last Name}}</div>',`<div class="title">${firstName} ${lastName}</div>`)
                                .replace('<td>{{Tourist}}</td>',`<td>${lastName}</td>`)
                                .replace('<p>Application Number : {{1698348185}}</p>',`<p>Application Number : ${Application_id}</p>`)
                                .replace('<td>{{gulidy@clout.wiki}}</td>',`<td>${email}</td>`);


    
        // Send the modified HTML content as the response
        res.send(modifiedHtml);
    });
});



module.exports = router;
