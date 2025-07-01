class APIResponse {
    constructor(data=null, successMessage=null, errorMessage=null, status=null){
        this.status = status;
        this.data = data;
        this.successMessage = successMessage;
        this.errorMessage = errorMessage;
        this.success = errorMessage === null;
        this.timestamp = new Date().toISOString();
    }

    static success(data, message="Operation completed successfully", status=200){
        return new APIResponse(data, message, null, status);
    }

    static created(data, message="Resource created sucessfully", status=201){
        return new APIResponse(data, message, null, status);
    }

    static noContent(message="Resource deleted successfully", status=204){
        return new APIResponse(null, message, null, status);
    }

    static badRequest(message="Missing required fields", status=400){
        return new APIResponse(null, null, message, status)
    }

    static unauthorized(message="Unauthorized access", status=401){
        return new APIResponse(null, null, message, status);
    }

    static notFound(message="Resource not found", status=404){
        return new APIResponse(null, null, message, status);
    }

    static error(message="Internal server error", status=500){
        return new APIResponse(null, null, message, status);
    }

    toJSON() {
        return {
            status: this.status,
            success: this.success,
            data: this.data,
            successMessage: this.successMessage,
            errorMessage: this.errorMessage,
            timestamp: this.timestamp
        };
    }
}

export default APIResponse;