enron = {}

enron.communication_pair = function () {
	db.messages.aggregate([{
		$unwind: "$headers.To"
	}, {
		$group: {
			_id: {
				from: "$headers.From",
				to: "$headers.To"
			},
			count: {
				$sum: 1
			}
		}
	}, {
		$sort: {
			count: -1
		}
	}])	
}