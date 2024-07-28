const UserService = require("../services/user.services");

exports.register = async (req, res, next) => {
    try {
        const { email, fullname, phonenumber, password } = req.body;
        const successRes = await UserService.registeruser(email, fullname, phonenumber, password);

        res.json({ status: true, success: "User Registered Successfully" });
    } catch (error) {
        next(error);
    }
};

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        console.log("Password:", password);

        const user = await UserService.checkuser(email);
        console.log("User:", user);

        if (!user) {
            throw new Error('User does not exist');
        }

        const isMatch = await user.comparePassword(password);
        if (!isMatch) {
            throw new Error('Password invalid');
        }
        let tokenData = { id: user._id, email: user.email };
        const token = await UserService.generateToken(tokenData, "Hardik", "1hr");

        res.status(200).json({ status: true, token: token });
    } catch (error) {
        next(error);
    }
};  
