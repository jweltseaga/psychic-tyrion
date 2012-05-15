require('../test_helper.js').controller('campaigns', module.exports);

var sinon  = require('sinon');

function ValidAttributes () {
    return {
        title: '',
        createdAt: '',
        createdBy: '',
        imgUrl: '',
        published: '',
        salesEmail: '',
        campaignText: '',
        slug: ''
    };
}

exports['campaigns controller'] = {

    'GET new': function (test) {
        test.get('/campaigns/new', function () {
            test.success();
            test.render('new');
            test.render('form.' + app.set('view engine'));
            test.done();
        });
    },

    'GET index': function (test) {
        test.get('/campaigns', function () {
            test.success();
            test.render('index');
            test.done();
        });
    },

    'GET edit': function (test) {
        var find = Campaign.find;
        Campaign.find = sinon.spy(function (id, callback) {
            callback(null, new Campaign);
        });
        test.get('/campaigns/42/edit', function () {
            test.ok(Campaign.find.calledWith('42'));
            Campaign.find = find;
            test.success();
            test.render('edit');
            test.done();
        });
    },

    'GET show': function (test) {
        var find = Campaign.find;
        Campaign.find = sinon.spy(function (id, callback) {
            callback(null, new Campaign);
        });
        test.get('/campaigns/42', function (req, res) {
            test.ok(Campaign.find.calledWith('42'));
            Campaign.find = find;
            test.success();
            test.render('show');
            test.done();
        });
    },

    'POST create': function (test) {
        var campaign = new ValidAttributes;
        var create = Campaign.create;
        Campaign.create = sinon.spy(function (data, callback) {
            test.strictEqual(data, campaign);
            callback(null, campaign);
        });
        test.post('/campaigns', {Campaign: campaign}, function () {
            test.redirect('/campaigns');
            test.flash('info');
            test.done();
        });
    },

    'POST create fail': function (test) {
        var campaign = new ValidAttributes;
        var create = Campaign.create;
        Campaign.create = sinon.spy(function (data, callback) {
            test.strictEqual(data, campaign);
            callback(new Error, campaign);
        });
        test.post('/campaigns', {Campaign: campaign}, function () {
            test.success();
            test.render('new');
            test.flash('error');
            test.done();
        });
    },

    'PUT update': function (test) {
        Campaign.find = sinon.spy(function (id, callback) {
            test.equal(id, 1);
            callback(null, {id: 1, updateAttributes: function (data, cb) { cb(null); }});
        });
        test.put('/campaigns/1', new ValidAttributes, function () {
            test.redirect('/campaigns/1');
            test.flash('info');
            test.done();
        });
    },

    'PUT update fail': function (test) {
        Campaign.find = sinon.spy(function (id, callback) {
            test.equal(id, 1);
            callback(null, {id: 1, updateAttributes: function (data, cb) { cb(new Error); }});
        });
        test.put('/campaigns/1', new ValidAttributes, function () {
            test.success();
            test.render('edit');
            test.flash('error');
            test.done();
        });
    },

    'DELETE destroy': function (test) {
        test.done();
    },

    'DELETE destroy fail': function (test) {
        test.done();
    }
};

