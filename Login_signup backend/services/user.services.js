const UserModel = require("../model/user.model");
const jwt = require('jsonwebtoken'); 

class userService {
    static async registeruser(email, fullname, phonenumber, password) {
        try {
            const createUser = new UserModel({ email, fullname, phonenumber, password });
            await createUser.save();
            return { message: 'User registered successfully' };
        } catch (err) {
            console.error('Error registering user:', err);
            if (err.code === 11000) {
                throw new Error('Email or phone number already exists');
            }
            throw new Error('Server error');
        }
    };

    static async checkuser(email) {
        try {
            return await UserModel.findOne({ email });
        } catch (error) {
            throw error;
        }
    };

    static async generateToken(tokenData, secretKey, jwt_expire) {
        return jwt.sign(tokenData, secretKey, { expiresIn: jwt_expire });
    }
}

module.exports = userService;
