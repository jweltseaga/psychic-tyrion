require('../test_helper.js').controller('brands', module.exports);

var sinon  = require('sinon');

function ValidAttributes () {
    return {
        name: '',
        phone: '',
        defaultEmail: '',
        image: ''
    };
}

exports['brands controller'] = {

    'GET new': function (test) {
        test.get('/brands/new', function () {
            test.success();
            test.render('new');
            test.render('form.' + app.set('view engine'));
            test.done();
        });
    },

    'GET index': function (test) {
        test.get('/brands', function () {
            test.success();
            test.render('index');
            test.done();
        });
    },

    'GET edit': function (test) {
        var find = Brand.find;
        Brand.find = sinon.spy(function (id, callback) {
            callback(null, new Brand);
        });
        test.get('/brands/42/edit', function () {
            test.ok(Brand.find.calledWith('42'));
            Brand.find = find;
            test.success();
            test.render('edit');
            test.done();
        });
    },

    'GET show': function (test) {
        var find = Brand.find;
        Brand.find = sinon.spy(function (id, callback) {
            callback(null, new Brand);
        });
        test.get('/brands/42', function (req, res) {
            test.ok(Brand.find.calledWith('42'));
            Brand.find = find;
            test.success();
            test.render('show');
            test.done();
        });
    },

    'POST create': function (test) {
        var brand = new ValidAttributes;
        var create = Brand.create;
        Brand.create = sinon.spy(function (data, callback) {
            test.strictEqual(data, brand);
            callback(null, brand);
        });
        test.post('/brands', {Brand: brand}, function () {
            test.redirect('/brands');
            test.flash('info');
            test.done();
        });
    },

    'POST create fail': function (test) {
        var brand = new ValidAttributes;
        var create = Brand.create;
        Brand.create = sinon.spy(function (data, callback) {
            test.strictEqual(data, brand);
            callback(new Error, brand);
        });
        test.post('/brands', {Brand: brand}, function () {
            test.success();
            test.render('new');
            test.flash('error');
            test.done();
        });
    },

    'PUT update': function (test) {
        Brand.find = sinon.spy(function (id, callback) {
            test.equal(id, 1);
            callback(null, {id: 1, updateAttributes: function (data, cb) { cb(null); }});
        });
        test.put('/brands/1', new ValidAttributes, function () {
            test.redirect('/brands/1');
            test.flash('info');
            test.done();
        });
    },

    'PUT update fail': function (test) {
        Brand.find = sinon.spy(function (id, callback) {
            test.equal(id, 1);
            callback(null, {id: 1, updateAttributes: function (data, cb) { cb(new Error); }});
        });
        test.put('/brands/1', new ValidAttributes, function () {
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

