'use strict';

const { response } = require("express");
const createJsonError = require("../../errors/create-json-error");
const throwJsonError = require("../../errors/throw-json-error");
const { findAnswerById } = require("../../repositories/answers.repository");


const getAnswerById = async(req, res = response) => {

    try {
        const { id } = req.params;
        const answer = await findAnswerById(id);
        if ( !answer ) {
            throwJsonError(404, "Answer not found");
        }

        res.status(200).json({
            answer
        });
    } catch (error) {
        createJsonError(error, res);
    }
};

module.exports = {
    getAnswerById,
};